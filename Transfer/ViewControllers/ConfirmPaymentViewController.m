//
//  ConfirmPaymentViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 5/8/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <OHAttributedLabel/OHAttributedLabel.h>
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
#import "AnalyticsCoordinator.h"
#import "NSMutableString+Issues.h"
#import "Currency.h"
#import "PlainPresentationCell.h"
#import "MOMStyle.h"



@interface ConfirmPaymentViewController ()

@property (nonatomic, strong) IBOutlet UIButton *actionButton;
@property (nonatomic, strong) IBOutlet UIView *headerView;

@property (nonatomic, strong) PlainPresentationCell *yourDepositCell;
@property (nonatomic, strong) PlainPresentationCell *exchangedToCell;
@property (nonatomic, strong) PlainPresentationCell *senderNameCell;
@property (nonatomic, strong) PlainPresentationCell *senderEmailCell;
@property (nonatomic, strong) PlainPresentationCell *receiverNameCell;
@property (nonatomic, strong) NSArray *receiverFieldCells;
@property (nonatomic, strong) TextEntryCell *referenceCell;
@property (nonatomic, strong) TextEntryCell *receiverEmailCell;
@property (nonatomic, strong) IBOutlet UIButton *contactSupportButton;

@property (nonatomic, strong) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *footerLabel;

@property (nonatomic, strong) TransferwiseOperation *executedOperation;

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
}

- (void)createContent
{
    NSMutableArray *receiverCells = [NSMutableArray array];
    
    NSArray *fieldCells = [self buildFieldCells];
    [self setReceiverFieldCells:fieldCells];
    [receiverCells addObjectsFromArray:fieldCells];

    
    NSMutableArray *transferCells = [NSMutableArray array];
    PlainPresentationCell *yourDepositCell = [self.tableView dequeueReusableCellWithIdentifier:PlainPresentationCellIdentifier];
    [self setYourDepositCell:yourDepositCell];
    [transferCells addObject:yourDepositCell];
    
    PlainPresentationCell *exchangedToCell = [self.tableView dequeueReusableCellWithIdentifier:PlainPresentationCellIdentifier];
    [self setExchangedToCell:exchangedToCell];
    [transferCells addObject:exchangedToCell];
    Payment *payment = self.payment;
    if (payment.targetCurrency.recipientEmailRequiredValue && [payment.recipient.email length] == 0)
    {
        TextEntryCell *receiverEmailCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
        [self setReceiverEmailCell:receiverEmailCell];
        [receiverEmailCell.entryField setKeyboardType:UIKeyboardTypeEmailAddress];
        [receiverEmailCell.entryField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [transferCells addObject:receiverEmailCell];
    }
    
    TextEntryCell *referenceCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
	referenceCell.maxValueLength = [self getReferenceMaxLength:self.payment];
	referenceCell.validateAlphaNumeric = YES;
	[self setReferenceCell:referenceCell];
    [referenceCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [transferCells addObject:referenceCell];

    NSMutableArray *presented = [NSMutableArray array];
    [presented addObject:receiverCells];
    [presented addObject:transferCells];

    [self setPresentedSectionCells:presented];

    [self.actionButton setTitle:self.footerButtonTitle forState:UIControlStateNormal];
}

- (NSArray *)buildFieldCells
{
    Recipient *recipient = self.payment.recipient;
    NSMutableArray *cells = [NSMutableArray array];
    for (TypeFieldValue *value in recipient.fieldValues) {
        PlainPresentationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:PlainPresentationCellIdentifier];
        [cell configureWithTitle:value.valueForField.title text:[value presentedValue]];
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
}

- (void)fillDataCells
{
    Payment *payment = self.payment;
    
    [self.yourDepositCell configureWithTitle:NSLocalizedString(self.payment.isFixedAmountValue?@"confirm.payment.deposit.fixed.title.label":@"confirm.payment.deposit.title.label", nil) text:[payment payInStringWithCurrency]];
    
    [self.exchangedToCell configureWithTitle:NSLocalizedString(@"confirm.payment.exchangerate.title.label", nil) text:[NSString stringWithFormat:@"%f",payment.conversionRateValue]];


    
    [self fillHeaderText];
   
    //Resize header to fit text
    CGRect textFrame = self.headerLabel.frame;
    CGFloat originalHeight = textFrame.size.height;
    [self.headerLabel sizeToFit];
    textFrame.size.height = MAX(self.headerLabel.frame.size.height + 8.0f,originalHeight);
    CGRect headerFrame = self.headerView.frame;
    headerFrame.size.height += (textFrame.size.height - originalHeight);
    self.headerView.frame = headerFrame;
    self.headerLabel.frame = textFrame;
    self.tableView.tableHeaderView = self.headerView;

    self.footerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"", nil),self.payment.recipient.name];
    
    [self.senderNameCell configureWithTitle:NSLocalizedString(@"confirm.payment.sender.marker.label", nil) text:[self getSenderName:payment]];
    
    [self.receiverNameCell configureWithTitle:NSLocalizedString(@"confirm.payment.recipient.marker.label", nil) text:[payment.recipient name]];

    
    [self.receiverEmailCell setEditable:YES];
    [self.receiverEmailCell configureWithTitle:NSLocalizedString(@"confirm.payment.email.label", nil) value:[payment.recipient email]];

    [self.referenceCell setEditable:YES];
    [self.referenceCell configureWithTitle:NSLocalizedString(@"confirm.payment.reference.label", nil) value:@""];
	[self.referenceCell.entryField setAutocorrectionType:UITextAutocorrectionTypeDefault];
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
    dateFormatter.dateFormat = @"EEEE d MMMM YYYY 'at' ha z";
    NSString *dateString = [dateFormatter stringFromDate:self.payment.estimatedDelivery];
    NSString *amountString = [NSString stringWithFormat:NSLocalizedString(self.payment.isFixedAmountValue?@"confirm.payment.fixed.target.sum.format":@"confirm.payment.target.sum.format",nil),[self.payment payOutStringWithCurrency]];
    NSString *headerText = [NSString stringWithFormat:NSLocalizedString(@"confirm.payment.header.format",nil),dateString,amountString,self.payment.recipient.name];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:headerText];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromStyle:@"darkfont"] range:[headerText rangeOfString:amountString]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromStyle:@"darkfont"] range:[headerText rangeOfString:self.payment.recipient.name]];
    self.headerLabel.attributedText = attributedString;
}

- (void)fillDeliveryDetails:(UILabel *)label
{
    NSString *rateString = [self.payment rateString];
    NSString *messageString = [NSString stringWithFormat:NSLocalizedString(@"confirm.payment.estimated.exchange.rate.message", nil), rateString];
    NSAttributedString *exchangeRateString = [self attributedStringWithBase:messageString markedString:rateString];

    NSString *dateString = [self.payment paymentDateString];
    NSString *dateMessageString = [NSString stringWithFormat:NSLocalizedString(@"confirm.payment.delivery.date.message", nil), dateString];
    NSAttributedString *paymentDateString = ([dateString hasValue] ? [self attributedStringWithBase:dateMessageString markedString:dateString] : [NSAttributedString attributedStringWithString:@""]);

    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    [result appendAttributedString:exchangeRateString];
    [result appendAttributedString:[NSAttributedString attributedStringWithString:@"\n"]];
    [result appendAttributedString:paymentDateString];

    [label setAttributedText:result];
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
        else if([payment.targetCurrency.code caseInsensitiveCompare:@"USD"] == NSOrderedSame)
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

-(void)sendForValidation
{
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"confirm.payment.creating.message", nil)];
    
    PendingPayment *input = [self.objectModel pendingPayment];
    
    NSString *reference = [self.referenceCell value];
	
    [input setReference:reference];
    
    NSString *email = self.receiverEmailCell?[self.receiverEmailCell value]:self.payment.recipient.email;
    if ([email hasValue]) {
        [input setRecipientEmail:email];
    }
    
    [self.paymentFlow validatePayment:input.objectID successBlock:^{
        [hud hide];
    } errorHandler:^(NSError *error) {
        [hud hide];
        if (error) {
            [[GoogleAnalytics sharedInstance] sendAlertEvent:@"CreatingPaymentAlert" withLabel:[error localizedTransferwiseMessage]];
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"confirm.payment.payment.error.title", nil) error:error];
            [alertView show];
        }
    }];

}

- (IBAction)contactSupportPressed {
	
}

- (NSAttributedString *)attributedStringWithBase:(NSString *)baseString markedString:(NSString *)marked {
	NSRange rateRange;
	if ([marked hasValue]) {
		rateRange = [baseString rangeOfString:marked];
	} else {
		rateRange = NSMakeRange(0, 0);
	}

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:baseString];

    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    [attributedString addAttribute:NSParagraphStyleAttributeName
                 value:paragraphStyle
                 range:NSMakeRange(0, baseString.length)];
    
    [attributedString setFont:[UIFont systemFontOfSize:12]];
    [attributedString setFont:[UIFont boldSystemFontOfSize:12] range:rateRange];
    [attributedString setTextColor:[UIColor blackColor]];
    return [[NSAttributedString alloc] initWithAttributedString:attributedString];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
