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
#import "ConfirmPaymentCell.h"
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



static NSUInteger const kSenderSection = 1;

@interface ConfirmPaymentViewController ()

@property (nonatomic, strong) IBOutlet UIView *footerView;
@property (nonatomic, strong) IBOutlet UIButton *footerButton;
@property (nonatomic, strong) IBOutlet UIView *headerView;

@property (nonatomic, strong) ConfirmPaymentCell *yourDepositCell;
@property (nonatomic, strong) ConfirmPaymentCell *exchangedToCell;
@property (nonatomic, strong) ConfirmPaymentCell *senderNameCell;
@property (nonatomic, strong) ConfirmPaymentCell *senderEmailCell;
@property (nonatomic, strong) ConfirmPaymentCell *receiverNameCell;
@property (nonatomic, strong) NSArray *receiverFieldCells;
@property (nonatomic, strong) TextEntryCell *referenceCell;
@property (nonatomic, strong) TextEntryCell *receiverEmailCell;
@property (nonatomic, strong) IBOutlet UIButton *contactSupportButton;

@property (nonatomic, strong) IBOutlet OHAttributedLabel *estimatedExchangeRateLabel;

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

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];
    [self.tableView setDelegate:self];

    [self.tableView registerNib:[UINib nibWithNibName:@"ConfirmPaymentCell" bundle:nil] forCellReuseIdentifier:TWConfirmPaymentCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];
}

- (void)createContent
{
    NSMutableArray *transferCells = [NSMutableArray array];
    ConfirmPaymentCell *yourDepositCell = [self.tableView dequeueReusableCellWithIdentifier:TWConfirmPaymentCellIdentifier];
    [self setYourDepositCell:yourDepositCell];
    [transferCells addObject:yourDepositCell];
    
    ConfirmPaymentCell *exchangedToCell = [self.tableView dequeueReusableCellWithIdentifier:TWConfirmPaymentCellIdentifier];
    [self setExchangedToCell:exchangedToCell];
    [transferCells addObject:exchangedToCell];

    NSMutableArray *senderCells = [NSMutableArray array];
    ConfirmPaymentCell *senderNameCell = [self.tableView dequeueReusableCellWithIdentifier:TWConfirmPaymentCellIdentifier];
    [self setSenderNameCell:senderNameCell];
    [senderCells addObject:senderNameCell];
    
    NSMutableArray *receiverCells = [NSMutableArray array];
    ConfirmPaymentCell *receiverNameCell = [self.tableView dequeueReusableCellWithIdentifier:TWConfirmPaymentCellIdentifier];
    [self setReceiverNameCell:receiverNameCell];
    [receiverNameCell.imageView setImage:[UIImage imageNamed:@"ProfileIcon.png"]];
    [receiverCells addObject:receiverNameCell];

    NSArray *fieldCells = [self buildFieldCells];
    [self setReceiverFieldCells:fieldCells];
    [receiverCells addObjectsFromArray:fieldCells];

    Payment *payment = self.payment;
    if (payment.targetCurrency.recipientEmailRequiredValue && [payment.recipient.email length] == 0)
    {
        TextEntryCell *receiverEmailCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
        [self setReceiverEmailCell:receiverEmailCell];
        [receiverEmailCell.entryField setKeyboardType:UIKeyboardTypeEmailAddress];
        [receiverEmailCell.entryField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [receiverCells addObject:receiverEmailCell];
    }
    
    TextEntryCell *referenceCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
	referenceCell.maxValueLength = [self getReferenceMaxLength:self.payment];
	referenceCell.validateAlphaNumeric = YES;
	[self setReferenceCell:referenceCell];
    [referenceCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [receiverCells addObject:referenceCell];

    NSMutableArray *presented = [NSMutableArray array];
    [presented addObject:transferCells];

    if (self.showContactSupportCell) {
        [self.contactSupportButton setTitle:NSLocalizedString(@"support.contact.cell.label", nil) forState:UIControlStateNormal];
    } else {
        [self.contactSupportButton removeFromSuperview];
        CGRect headerFrame = self.headerView.frame;
        headerFrame.size.height = CGRectGetMinY(self.contactSupportButton.frame);
        [self.headerView setFrame:headerFrame];

        if (self.reportingType == ConfirmPaymentReportingLoggedIn) {
            [[GoogleAnalytics sharedInstance] sendScreen:@"Confirm payment 2"];
        } else {
            [[GoogleAnalytics sharedInstance] sendScreen:@"Confirm payment"];
        }

        [[AnalyticsCoordinator sharedInstance] confirmPaymentScreenShown];
    }

    [presented addObject:senderCells];
    [presented addObject:receiverCells];

    [self setPresentedSectionCells:presented];

    [self.tableView setTableFooterView:self.footerView];
    [self.footerButton setTitle:self.footerButtonTitle forState:UIControlStateNormal];
}

- (NSArray *)buildFieldCells
{
    Recipient *recipient = self.payment.recipient;
    NSMutableArray *cells = [NSMutableArray array];
    for (TypeFieldValue *value in recipient.fieldValues) {
        ConfirmPaymentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TWConfirmPaymentCellIdentifier];
        [cell.textLabel setText:value.valueForField.title];
        [cell.detailTextLabel setText:[value presentedValue]];
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
}

- (void)fillDataCells
{
    Payment *payment = self.payment;
    
    [self.yourDepositCell.textLabel setText:NSLocalizedString(@"confirm.payment.deposit.title.label", nil)];
    [self.yourDepositCell.detailTextLabel setText:[payment payInStringWithCurrency]];
    
    [self.exchangedToCell.textLabel setText:NSLocalizedString(@"confirm.payment.exchanged.to.title.label", nil)];
    [self.exchangedToCell.detailTextLabel setText:[payment payOutStringWithCurrency]];

    [self.estimatedExchangeRateLabel setAutomaticallyAddLinksForType:0];
    [self fillDeliveryDetails:self.estimatedExchangeRateLabel];
   
    //Resize header to fit text
    CGRect textFrame = self.estimatedExchangeRateLabel.frame;
    CGFloat originalHeight = textFrame.size.height;
    CGRect attributedStringBounds = [self.estimatedExchangeRateLabel.attributedText boundingRectWithSize:CGSizeMake(textFrame.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    textFrame.size.height = MAX(attributedStringBounds.size.height + 8.0f,originalHeight);
    CGRect headerFrame = self.headerView.frame;
    headerFrame.size.height += (textFrame.size.height - originalHeight);
    self.headerView.frame = headerFrame;
    self.estimatedExchangeRateLabel.frame = textFrame;

    [self.senderNameCell.detailTextLabel setText:NSLocalizedString(@"confirm.payment.sender.marker.label", nil)];
	[self.senderNameCell.textLabel setText:[self getSenderName:payment]];
	
    if (![payment businessProfileUsed])
	{
		[self.senderNameCell.imageView setImage:[UIImage imageNamed:@"ProfileIcon.png"]];
    }

    [self.receiverNameCell.textLabel setText:[payment.recipient name]];
    [self.receiverNameCell.detailTextLabel setText:NSLocalizedString(@"confirm.payment.recipient.marker.label", nil)];
    
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

- (void)fillDeliveryDetails:(OHAttributedLabel *)label
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


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == kSenderSection)
	{
        return _headerView;
    }
    return [super tableView:tableView viewForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == kSenderSection)
	{
        return _headerView.frame.size.height;
    }
    return [super tableView:tableView heightForHeaderInSection:section];
}
@end
