//
//  ConfirmPaymentViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 5/8/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ConfirmPaymentViewController.h"
#import "UIColor+Theme.h"
#import "PlainPresentationCell.h"
#import "CalculationResult.h"
#import "TRWProgressHUD.h"
#import "TRWAlertView.h"
#import "TextEntryCell.h"
#import "PaymentFlow.h"
#import "RecipientType.h"
#import "ObjectModel+RecipientTypes.h"
#import "Recipient.h"
#import "ObjectModel+PendingPayments.h"
#import "PendingPayment.h"
#import "TypeFieldValue.h"
#import "RecipientTypeField.h"
#import "User.h"
#import "BusinessProfile.h"
#import "PersonalProfile.h"
#import "NSString+Validation.h"
#import "TransferBackButtonItem.h"
#import "GoogleAnalytics.h"
#import "NSError+TRWErrors.h"
#import "NSMutableString+Issues.h"
#import "Currency.h"
#import "PlainPresentationCell.h"
#import "MOMStyle.h"
#import "RecipientUpdateOperation.h"
#import "Mixpanel+Customisation.h"
#import "UIView+Container.h"
#import "UITextField+CaretPosition.h"
#import "ColoredButton.h"
#import "PendingPayment+ColoredButton.h"

@interface ConfirmPaymentViewController ()

@property (nonatomic, strong) IBOutlet ColoredButton *actionButton;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (nonatomic, strong) PlainPresentationCell *yourDepositCell;
@property (nonatomic, strong) PresentationCell *exchangeRateCell;
@property (nonatomic, strong) PlainPresentationCell *senderEmailCell;
@property (nonatomic, strong) PlainPresentationCell *receiverAmountCell;
@property (nonatomic, strong) PlainPresentationCell *estimatedDeliveryCell;
@property (nonatomic, strong) NSArray *receiverFieldCells;
@property (nonatomic, strong) TextEntryCell *referenceCell;
@property (nonatomic, strong) TextEntryCell *receiverEmailCell;
@property (nonatomic, strong) IBOutlet UIButton *contactSupportButton;
@property (nonatomic, strong) TRWProgressHUD *hud;

@property (nonatomic, strong) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *footerLabel;

@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@property (nonatomic, copy) TRWActionBlock animatedSuccessWrapper;

//iPad
@property (nonatomic,weak) IBOutlet UITextField *referenceField;
@property (nonatomic,weak) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray* separatorLines;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray* emailFieldViews;

- (IBAction)footerButtonPressed:(id)sender;

@end

@implementation ConfirmPaymentViewController

- (id)init
{
    self = [super initWithNibName:@"ConfirmPaymentViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    [self.tableView setDelegate:self];

    [self.tableView registerNib:[UINib nibWithNibName:@"PlainPresentationCell" bundle:nil] forCellReuseIdentifier:PlainPresentationCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"TwoFieldPresentationCell" bundle:nil] forCellReuseIdentifier:@"TwoFieldPresentationCell"];
    
    //Set background colour again because of ios 8.1 bug
    self.tableView.bgStyle = self.tableView.bgStyle;
    
    [[Mixpanel sharedInstance] sendPageView:MPConfirmation withProperties:[self.payment trackingProperties]];

    ColoredButton* coloredButton = (ColoredButton*)self.actionButton;
    PendingPayment* pendingPayment = [self.objectModel pendingPayment];
    [pendingPayment addProgressAnimationToButton:coloredButton];

    __weak typeof(self) weakSelf = self;
    self.animatedSuccessWrapper = ^{
        [coloredButton animateProgressFrom:[pendingPayment.paymentFlowProgress floatValue] to:1.0f delay:0.0f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.sucessBlock();
            });
    };
    
}

- (void)createContent
{
    Payment *payment = self.payment;
    
    NSMutableArray *cells = [NSMutableArray array];

    if(!IPAD)
    {
        NSArray *fieldCells = [self buildFieldCells];
        [self setReceiverFieldCells:fieldCells];
        [cells addObjectsFromArray:fieldCells];
        

        PlainPresentationCell *yourDepositCell = [self.tableView dequeueReusableCellWithIdentifier:PlainPresentationCellIdentifier];
        [self setYourDepositCell:yourDepositCell];
        yourDepositCell.backgroundColor = [UIColor clearColor];
        [cells addObject:yourDepositCell];
        
        PresentationCell *exchangedToCell = [self.tableView dequeueReusableCellWithIdentifier:@"TwoFieldPresentationCell"];
        [self setExchangeRateCell:exchangedToCell];
        exchangedToCell.backgroundColor = [UIColor clearColor];
        [cells addObject:exchangedToCell];
        
        TextEntryCell *referenceCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
        referenceCell.maxValueLength = [self getReferenceMaxLength:self.payment];
        referenceCell.validateAlphaNumeric = YES;
        [self setReferenceCell:referenceCell];
        [referenceCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
        [cells addObject:referenceCell];
        
        if ([payment.recipient.email length] == 0)
        {
            TextEntryCell *receiverEmailCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
            [self setReceiverEmailCell:receiverEmailCell];
            [receiverEmailCell.entryField setKeyboardType:UIKeyboardTypeEmailAddress];
            [receiverEmailCell.entryField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [cells addObject:receiverEmailCell];
        }
    }
    else
    {
      
        PlainPresentationCell *yourDepositCell = [self.tableView dequeueReusableCellWithIdentifier:PlainPresentationCellIdentifier];
        [self setYourDepositCell:yourDepositCell];
        [cells addObject:yourDepositCell];

        PlainPresentationCell *receiverAmountCell = [self.tableView dequeueReusableCellWithIdentifier:PlainPresentationCellIdentifier];
        [self setReceiverAmountCell:receiverAmountCell];
        [cells addObject:receiverAmountCell];
		
		if (payment.estimatedDelivery)
		{
			PlainPresentationCell *deliveryDateCell = [self.tableView dequeueReusableCellWithIdentifier:PlainPresentationCellIdentifier];
			[self setEstimatedDeliveryCell:deliveryDateCell];
			[cells addObject:deliveryDateCell];
		}
		
        NSArray *fieldCells = [self buildFieldCells];
        [self setReceiverFieldCells:fieldCells];
        [cells addObjectsFromArray:fieldCells];
      
        PresentationCell *exchangedToCell = [self.tableView dequeueReusableCellWithIdentifier:@"TwoFieldPresentationCell"];
        [self setExchangeRateCell:exchangedToCell];
        [cells addObject:exchangedToCell];
        
        for(UITableView* cell in cells)
        {
            cell.backgroundColor = [UIColor clearColor];
        }
        
        self.referenceField.delegate = self;
        
        self.emailField.delegate = self;
        if ([payment.recipient.email length] == 0)
        {
            for(UIView* view in self.emailFieldViews)
            {
                view.hidden = NO;
            }
            self.emailField.returnKeyType = UIReturnKeyDone;
            self.referenceField.returnKeyType = UIReturnKeyNext;
        }
        else
        {
            self.referenceField.returnKeyType = UIReturnKeyDone;
        }
        
        for(UIView* separatorLine in self.separatorLines)
        {
            CGRect newFrame = separatorLine.frame;
            newFrame.size.height = 1.0/[[UIScreen mainScreen] scale];
            separatorLine.frame = newFrame;
            separatorLine.bgStyle = @"SeparatorGrey";
        }
    }
    

    NSMutableArray *presented = [NSMutableArray array];
    [presented addObject:cells];
    
    [self setPresentedSectionCells:presented];
    
    [self.actionButton setTitle:self.footerButtonTitle forState:UIControlStateNormal];
}

- (NSArray *)buildFieldCells
{
    Recipient *recipient = self.payment.recipient;
    NSMutableArray *cells = [NSMutableArray array];
    for (TypeFieldValue *value in recipient.fieldValues)
	{
        PlainPresentationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:PlainPresentationCellIdentifier];
        [cell configureWithTitle:value.valueForField.title text:[value presentedValue]];
        cell.backgroundColor = [UIColor clearColor];
        [cells addObject:cell];
    }
    return [NSArray arrayWithArray:cells];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationItem setTitle:NSLocalizedString(@"confirm.payment.controller.title", nil)];

    [self createContent];
    [self fillDataCells];
    [self.tableView reloadData];

    [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self setupForOrientation:self.interfaceOrientation];
    
    if(self.reportingType == ConfirmPaymentReportingLoggedIn)
    {
        [[GoogleAnalytics sharedInstance] sendScreen:GAConfirmPayment2];
    }
    else if (self.reportingType == ConfirmPaymentReportingNotLoggedIn)
    {
        [[GoogleAnalytics sharedInstance] sendScreen:GAConfirmPayment];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.hud hide];
    [super viewWillDisappear:animated];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
        [self setupForOrientation:toInterfaceOrientation];
}

-(void)setupForOrientation:(UIInterfaceOrientation)orientation
{
	if(IPAD)
	{
		CGRect newHeaderFrame = self.headerView.frame;
		CGRect newFooterFrame = self.footerView.frame;
		if(UIInterfaceOrientationIsLandscape(orientation))
		{
			newHeaderFrame.size.height = 60.0f;
			newFooterFrame.size.height = 224.0f;
		}
		else
		{
			newHeaderFrame.size.height = 188.0f;
			newFooterFrame.size.height = 352.0f;
		}
		self.headerView.frame = newHeaderFrame;
		self.footerView.frame = newFooterFrame;
		self.tableView.tableHeaderView = self.headerView;
		self.tableView.tableFooterView = self.footerView;
	}
}

- (void)fillDataCells
{
    PendingPayment *payment = self.payment;
    
    [self.yourDepositCell configureWithTitle:NSLocalizedString(self.payment.isFixedAmountValue?@"confirm.payment.deposit.fixed.title.label":@"confirm.payment.deposit.title.label", nil) text:[payment payInStringWithCurrency]];
    
    NSString *exchangeRateTitle = NSLocalizedString([@"usd" caseInsensitiveCompare:self.payment.sourceCurrency.code] == NSOrderedSame ? @"confirm.payment.exchangerate.exact.title.label" : @"confirm.payment.exchangerate.title.label", nil);
    NSString *feeTitle =  NSLocalizedString(@"confirm.payment.fee.title.label", nil);
    [self.exchangeRateCell setTitles:exchangeRateTitle,feeTitle, nil];
    
    NSString* exchangeRate = [NSString stringWithFormat:@"%f",payment.conversionRateValue];
    NSString* fee = [NSString stringWithFormat:@"%0.2f %@",[payment transferwiseTransferFeeValue],payment.sourceCurrency.code];
    if(ABS([payment transferwiseTransferFeeValue]) < 0.005f)
    {
        fee = [fee stringByAppendingString:NSLocalizedString(@"why.popup.tw.fee.free", nil)];
    }
    [self.exchangeRateCell setValues:exchangeRate, fee, nil];
	

    
    if(!IPAD)
    {
        [self fillHeaderText];
        
        //Resize header to fit text
        [self resizeView:self.headerView toFitLabel:self.headerLabel];
        self.tableView.tableHeaderView = self.headerView;
        
        [self fillFooterText];
        //Resize footer to fit text
        [self resizeView:self.footerView toFitLabel:self.footerLabel];
        self.tableView.tableFooterView = self.footerView;
    
        [self.receiverEmailCell setEditable:YES];
        [self.receiverEmailCell configureWithTitle:NSLocalizedString(@"confirm.payment.email.label", nil) value:[payment.recipient email]];
        
        [self.referenceCell setEditable:YES];
        [self.referenceCell configureWithTitle:NSLocalizedString(@"confirm.payment.reference.label", nil) value:self.payment.paymentReference];
        [self.referenceCell.entryField setAutocorrectionType:UITextAutocorrectionTypeNo];
    }
    else
    {
        [self.receiverAmountCell configureWithTitle:[NSString stringWithFormat:NSLocalizedString(self.payment.isFixedAmountValue?@"confirm.payment.recipient.fixed.title.label":@"confirm.payment.recipient.title.label", nil),self.payment.recipient.name] text:[self.payment payOutStringWithCurrency]];
		
		if (self.payment.estimatedDelivery)
		{
			NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
			dateFormatter.dateFormat = @"EEEE dd/MM/yyyy 'at' ha";
			NSString *dateString = [dateFormatter stringFromDate:self.payment.estimatedDelivery];
			[self.estimatedDeliveryCell configureWithTitle:NSLocalizedString(@"confirm.payment.delivery.date.message",nil) text:dateString];
		}
		
        self.referenceField.placeholder = NSLocalizedString(@"confirm.payment.reference.label", nil);
        self.referenceField.text = self.payment.paymentReference;
        self.emailField.placeholder = NSLocalizedString(@"confirm.payment.email.label", nil);
    }
}

-(void)resizeView:(UIView*)view toFitLabel:(UILabel*)label
{
    //Resize header to fit text
    CGRect textFrame = label.frame;
    CGFloat originalHeight = textFrame.size.height;
    [label sizeToFit];
    textFrame.size.height = MAX(label.frame.size.height,originalHeight);
    CGRect viewFrame = view.frame;
    viewFrame.size.height += (textFrame.size.height - originalHeight);
    view.frame = viewFrame;
    label.frame = textFrame;
}

- (NSString *)getSenderName:(Payment *)payment
{
	if ([payment businessProfileUsed])
	{
        return payment.user.businessProfile.name;
    }
	else
	{
        return [payment.user.personalProfile fullName];
    }
}

- (NSInteger)getReferenceMaxLength:(Payment *)payment
{
	NSInteger maxLength = self.payment.targetCurrency.referenceMaxLengthValue;
	
	//15 is the current minimum maxLength
	//no currency is without maxLength from API
	//this is for cases when currencies have not been updated.
	return maxLength == 0 ? 15 : maxLength;
}

-(void)fillHeaderText
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE dd/MM/yyyy 'at' ha";
	NSString *amountString = [NSString stringWithFormat:NSLocalizedString(self.payment.isFixedAmountValue?@"confirm.payment.fixed.target.sum.format":@"confirm.payment.target.sum.format",nil),[self.payment payOutStringWithCurrency]];
	
	NSString *headerText;
	
	if (self.payment.estimatedDelivery)
	{
		NSString *dateString = [dateFormatter stringFromDate:self.payment.estimatedDelivery];
		headerText = [NSString stringWithFormat:NSLocalizedString(@"confirm.payment.header.format",nil), dateString, amountString, self.payment.recipient.name];
	}
	else
	{
		headerText = [NSString stringWithFormat:NSLocalizedString(@"confirm.payment.header.format.nodate",nil),amountString,self.payment.recipient.name];
	}
	
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:headerText];

    [self markSubstring:amountString inMutableAttributedString:attributedString];
    [self markSubstring:self.payment.recipient.name inMutableAttributedString:attributedString];

    self.headerLabel.attributedText = attributedString;
}

-(void)markSubstring:(NSString*)substring inMutableAttributedString:(NSMutableAttributedString*)attributedString
{
    if(!substring)
    {
        return;
    }
    NSRange range = [[attributedString string] rangeOfString:substring];
    
    if(range.location != NSNotFound && range.length > 0 && range.location + range.length <= attributedString.length)
    {
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromStyle:@"darkfont"] range:range];
        UIFont* boldText = [((MOMBasicStyle*)[MOMStyleFactory getStyleForIdentifier:@"heavy.@17"]) font];
        [attributedString addAttribute:NSFontAttributeName value:boldText range:range];
    }
}

-(void)fillFooterText
{
    self.footerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"confirm.payment.recipient.will.be.informed", nil),self.payment.recipient.name];
}

- (IBAction)footerButtonPressed:(id)sender {

    PendingPayment *payment = [self.objectModel pendingPayment];
    if(payment.targetCurrency.paymentReferenceAllowedValue)
    {
        [self sendForValidation];
    }
    else
    {
        NSString* message;
        NSDictionary* messageLookup = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NoRefCurrencyMessages" ofType:@"plist"]][payment.targetCurrency.code];
        if(messageLookup)
        {
            message = [NSString stringWithFormat:NSLocalizedString(@"confirm.payment.reference.message", nil),payment.recipient.name,payment.recipient.name,messageLookup[@"partner"],messageLookup[@"location"],payment.recipient.name];
        
        }
        else if([@"USD" caseInsensitiveCompare:payment.targetCurrency.code] == NSOrderedSame)
        {
            message = [NSString stringWithFormat:NSLocalizedString(@"confirm.payment.reference.message.USD", nil),payment.recipient.name,payment.recipient.name];
        }
        else
        {
            message = [NSString stringWithFormat:NSLocalizedString(@"confirm.payment.reference.message.default", nil),payment.recipient.name,payment.recipient.name,payment.recipient.name];
        }
        
         TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"",nil) message:message];
        [alertView setLeftButtonTitle:NSLocalizedString(@"confirm.payment.reference.message.confirm", nil) rightButtonTitle:NSLocalizedString(@"confirm.payment.reference.message.cancel", nil)];
        [alertView setLeftButtonAction:^{
            [self sendForValidation];
        }];
        [alertView show];
    }
}

- (NSAttributedString *)attributedStringWithBase:(NSString *)baseString markedString:(NSString *)marked {
	NSRange markedRange;
	if ([marked hasValue]) {
		markedRange = [baseString rangeOfString:marked];
	} else {
		markedRange = NSMakeRange(0, 0);
	}
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:baseString];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromStyle:@"darkfont"] range:markedRange];
    return attributedString;
}

-(void)sendForValidation
{
    self.hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [self.hud setMessage:NSLocalizedString(@"confirm.payment.creating.message", nil)];
    
    PendingPayment *input = [self.objectModel pendingPayment];
    
    NSString *reference = IPAD?self.referenceField.text:[self.referenceCell value];
	
    [input setPaymentReference:reference];
    
    NSString *email;
    BOOL emailAdded;
    if(IPAD)
    {
        email =  (!self.emailField.hidden) ? self.emailField.text : self.payment.recipient.email;
        emailAdded = (!self.emailField.hidden) && [email hasValue];
    }
    else
    {
        email = self.receiverEmailCell ? [self.receiverEmailCell value] : self.payment.recipient.email;
        emailAdded = (self.receiverEmailCell) && [email hasValue];
    }
    
    [input setRecipientEmail:email];
	
	__weak typeof(self) weakSelf = self;
	
    if(emailAdded)
    {
        self.payment.recipient.email = email;
        if(self.payment.recipient.remoteIdValue != 0)
        {
            //Pre-existing recipient
            RecipientUpdateOperation * updateOperation = [RecipientUpdateOperation instanceWithRecipient:self.payment.recipient objectModel:self.objectModel completionHandler:^(NSError *error) {
                if(error)
                {
                    [self.hud hide];
                    [[GoogleAnalytics sharedInstance] sendAlertEvent:GASavingrecipientalert withLabel:[error localizedTransferwiseMessage]];
                    TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"recipient.controller.validation.error.title", nil) error:error];
                    [alertView show];
                    return;
                }
                weakSelf.animatedSuccessWrapper();
            }];
            self.executedOperation = updateOperation;
            [updateOperation execute];
        }
        else
        {
            weakSelf.animatedSuccessWrapper();
        }
    }
    else
    {
        weakSelf.animatedSuccessWrapper();
    }
}

-(void)handleValidationError:(NSError *)error
{
    [self.hud hide];
    
    [self.actionButton animateProgressFrom:1.0f to:[[self.objectModel pendingPayment].paymentFlowProgress floatValue] delay:0.0f];
    if (error)
    {
        [[GoogleAnalytics sharedInstance] sendAlertEvent:GACreatingpaymentalert
                                               withLabel:[error localizedTransferwiseMessage]];
        TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"confirm.payment.payment.error.title", nil) error:error];
        [alertView show];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return IPAD?70.0f:60.0f;
}

-(void)keyboardWillShow:(NSNotification *)note
{
    if(IPAD)
    {
        CGRect newframe = [self.view.window convertRect:[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] toView:self.view];
        NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:curve];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, newframe.size.height, 0);
        self.tableView.contentOffset = CGPointMake(0, self.tableView.contentSize.height + newframe.size.height - self.tableView.frame.size.height);
        
        [UIView commitAnimations];
    }
    else
    {
        [super keyboardWillShow:note];
    }
}

-(void)keyboardWillHide:(NSNotification *)note
{
    if(IPAD)
    {
        NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:curve];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.tableView.contentInset = UIEdgeInsetsZero;
         [UIView commitAnimations];
    }
    else
    {
        [super keyboardWillHide:note];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.referenceField || textField == self.emailField)
    {
        if(self.referenceField == textField)
        {
            if(!self.emailField.hidden)
            {
                [self.emailField becomeFirstResponder];
                return YES;
            }
        }
    
        [textField resignFirstResponder];
        return YES;
    }
    else
    {
        return [super textFieldShouldReturn:textField];
    }
}
@end
