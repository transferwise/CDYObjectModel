//
//  ConfirmPaymentViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 5/8/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ConfirmPaymentViewController.h"
#import "UIColor+Theme.h"
#import "ConfirmPaymentCell.h"
#import "OHAttributedLabel/OHAttributedLabel.h"
#import "CalculationResult.h"
#import "TRWProgressHUD.h"
#import "TRWAlertView.h"
#import "TextEntryCell.h"
#import "NSString+Validation.h"
#import "PlainPaymentInput.h"
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

static NSUInteger const kSenderSection = 0;
static NSUInteger const kReceiverSection = 1;

@interface ConfirmPaymentViewController ()

@property (nonatomic, strong) IBOutlet UIView *footerView;
@property (nonatomic, strong) IBOutlet UIButton *footerButton;
@property (nonatomic, strong) IBOutlet UIView *headerView;

@property (nonatomic, strong) ConfirmPaymentCell *senderNameCell;
@property (nonatomic, strong) ConfirmPaymentCell *senderEmailCell;
@property (nonatomic, strong) ConfirmPaymentCell *receiverNameCell;
@property (nonatomic, strong) NSArray *receiverFieldCells;
@property (nonatomic, strong) TextEntryCell *referenceCell;
@property (nonatomic, strong) TextEntryCell *receiverEmailCell;

@property (nonatomic, strong) IBOutlet UILabel *yourDepositTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *yourDepositValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *exchangedToTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *exchangedToValueLabel;
@property (nonatomic, strong) IBOutlet OHAttributedLabel *estimatedExchangeRateLabel;
@property (nonatomic, strong) IBOutlet OHAttributedLabel *deliveryDateLabelLabel;

@property (nonatomic, strong) TransferwiseOperation *executedOperation;

- (IBAction)footerButtonPressed:(id)sender;

@end

@implementation ConfirmPaymentViewController

- (id)init {
    self = [super initWithNibName:@"ConfirmPaymentViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];

    [self.tableView registerNib:[UINib nibWithNibName:@"ConfirmPaymentCell" bundle:nil] forCellReuseIdentifier:TWConfirmPaymentCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];
}

- (void)createContent {
    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView setTableFooterView:self.footerView];

    NSMutableArray *senderCells = [NSMutableArray array];
    ConfirmPaymentCell *senderNameCell = [self.tableView dequeueReusableCellWithIdentifier:TWConfirmPaymentCellIdentifier];
    [self setSenderNameCell:senderNameCell];
    [senderCells addObject:senderNameCell];

    ConfirmPaymentCell *senderEmailCell = [self.tableView dequeueReusableCellWithIdentifier:TWConfirmPaymentCellIdentifier];
    [self setSenderEmailCell:senderEmailCell];
    [senderCells addObject:senderEmailCell];

    NSMutableArray *receiverCells = [NSMutableArray array];
    ConfirmPaymentCell *receiverNameCell = [self.tableView dequeueReusableCellWithIdentifier:TWConfirmPaymentCellIdentifier];
    [self setReceiverNameCell:receiverNameCell];
    [receiverNameCell.imageView setImage:[UIImage imageNamed:@"ProfileIcon.png"]];
    [receiverCells addObject:receiverNameCell];

    NSArray *fieldCells = [self buildFieldCells];
    [self setReceiverFieldCells:fieldCells];
    [receiverCells addObjectsFromArray:fieldCells];

    TextEntryCell *referenceCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setReferenceCell:referenceCell];
    [referenceCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [receiverCells addObject:referenceCell];

    TextEntryCell *receiverEmailCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setReceiverEmailCell:receiverEmailCell];
    [receiverEmailCell.entryField setKeyboardType:UIKeyboardTypeEmailAddress];
    [receiverEmailCell.entryField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [receiverCells addObject:receiverEmailCell];

    [self setPresentedSectionCells:@[senderCells, receiverCells]];

    [self.footerButton setTitle:self.footerButtonTitle forState:UIControlStateNormal];

    [self.yourDepositTitleLabel setText:NSLocalizedString(@"confirm.payment.deposit.title.label", nil)];

    CGRect depositTitleFrame = self.yourDepositTitleLabel.frame;
    CGSize depositTitleSize = [self.yourDepositTitleLabel sizeThatFits:CGSizeMake(NSUIntegerMax, CGRectGetHeight(depositTitleFrame))];
    depositTitleFrame.size.width = depositTitleSize.width;
    [self.yourDepositTitleLabel setFrame:depositTitleFrame];

    CGRect depositValueFrame = self.yourDepositValueLabel.frame;
    depositValueFrame.size.width = depositTitleSize.width;
    [self.yourDepositValueLabel setFrame:depositValueFrame];

    [self.exchangedToTitleLabel setText:NSLocalizedString(@"confirm.payment.exchanged.to.title.label", nil)];

    CGRect exchangedTitleFrame = self.exchangedToTitleLabel.frame;
    CGSize exchangedSize = [self.exchangedToTitleLabel sizeThatFits:CGSizeMake(NSUIntegerMax, CGRectGetHeight(exchangedTitleFrame))];
    CGFloat widthChange = exchangedSize.width - CGRectGetWidth(exchangedTitleFrame);
    exchangedTitleFrame.origin.x -= widthChange;
    exchangedTitleFrame.size.width += widthChange;
    [self.exchangedToTitleLabel setFrame:exchangedTitleFrame];

    CGRect exchangedValueFrame = self.exchangedToValueLabel.frame;
    exchangedValueFrame.origin.x = exchangedTitleFrame.origin.x;
    exchangedValueFrame.size.width = exchangedTitleFrame.size.width;
    [self.exchangedToValueLabel setFrame:exchangedValueFrame];
}

- (NSArray *)buildFieldCells {
    Recipient *recipient = [self.objectModel.pendingPayment recipient];
    NSMutableArray *cells = [NSMutableArray array];
    for (TypeFieldValue *value in recipient.fieldValues) {
        ConfirmPaymentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TWConfirmPaymentCellIdentifier];
        [cell.textLabel setText:value.valueForField.title];
        [cell.detailTextLabel setText:value.value];
        [cells addObject:cell];
    }
    return [NSArray arrayWithArray:cells];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setTitle:NSLocalizedString(@"confirm.payment.controller.title", nil)];

    [self createContent];
    [self fillDataCells];
    [self.tableView reloadData];
}

- (void)fillDataCells {
    PendingPayment *payment = [self.objectModel pendingPayment];

    [self.yourDepositValueLabel setText:[payment payInStringWithCurrency]];
    [self.exchangedToValueLabel setText:[payment payOutStringWithCurrency]];

    NSString *rateString = [payment rateString];
    NSString *messageString = [NSString stringWithFormat:NSLocalizedString(@"confirm.payment.estimated.exchange.rate.message", nil), rateString];
    NSAttributedString *exchangeRateString = [self attributedStringWithBase:messageString markedString:rateString];
    [self.estimatedExchangeRateLabel setAttributedText:exchangeRateString];

    NSString *dateString = [payment paymentDateString];
    NSString *dateMessageString = [NSString stringWithFormat:NSLocalizedString(@"confirm.payment.delivery.date.message", nil), dateString];
    NSAttributedString *paymentDateString = [self attributedStringWithBase:dateMessageString markedString:dateString];
    [self.deliveryDateLabelLabel setAttributedText:paymentDateString];

    [self.senderNameCell.detailTextLabel setText:NSLocalizedString(@"confirm.payment.sender.marker.label", nil)];

    if ([payment businessProfileUsed]) {
        [self.senderNameCell.textLabel setText:payment.user.businessProfile.name];
    } else {
        [self.senderNameCell.imageView setImage:[UIImage imageNamed:@"ProfileIcon.png"]];
        [self.senderNameCell.textLabel setText:[payment.user.personalProfile fullName]];
    }


    [self.senderEmailCell.textLabel setText:NSLocalizedString(@"confirm.payment.email.label", nil)];
    [self.senderEmailCell.detailTextLabel setText:payment.user.email];


    [self.receiverNameCell.textLabel setText:[payment.recipient name]];
    [self.receiverNameCell.detailTextLabel setText:NSLocalizedString(@"confirm.payment.recipient.marker.label", nil)];

    [self.receiverEmailCell setEditable:YES];
    [self.receiverEmailCell configureWithTitle:NSLocalizedString(@"confirm.payment.email.label", nil) value:[payment.recipient email]];

    [self.referenceCell setEditable:YES];
    [self.referenceCell configureWithTitle:NSLocalizedString(@"confirm.payment.reference.label", nil) value:@""];
}

- (IBAction)footerButtonPressed:(id)sender {
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
    [hud setMessage:NSLocalizedString(@"confirm.payment.creating.message", nil)];

    PlainPaymentInput *input = [[PlainPaymentInput alloc] init];
    //if (self.recipientProfile.id) {
    //    [input setRecipientId:self.recipientProfile.id];
    //}
    //[input setSourceCurrency:self.calculationResult.sourceCurrency];
    //[input setTargetCurrency:self.calculationResult.targetCurrency];
    //[input setAmount:self.calculationResult.amount];

    NSString *reference = [self.referenceCell value];
    if ([reference hasValue]) {
        [input setReference:reference];
    }

    NSString *email = [self.receiverEmailCell value];
    if ([email hasValue]) {
        [input setEmail:email];
    }

    [self.paymentFlow validatePayment:input errorHandler:^(NSError *error) {
        [hud hide];
        if (error) {
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"confirm.payment.payment.error.title", nil) error:error];
            [alertView show];
        }
    }];
}

- (NSAttributedString *)attributedStringWithBase:(NSString *)baseString markedString:(NSString *)marked {
    NSRange rateRange = [baseString rangeOfString:marked];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:baseString];

    OHParagraphStyle *paragraphStyle = [OHParagraphStyle defaultParagraphStyle];
    paragraphStyle.textAlignment = kCTTextAlignmentLeft;
    paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
    [attributedString setParagraphStyle:paragraphStyle];
    [attributedString setFont:[UIFont systemFontOfSize:12]];
    [attributedString setFont:[UIFont boldSystemFontOfSize:12] range:rateRange];
    [attributedString setTextColor:[UIColor blackColor]];
    return [[NSAttributedString alloc] initWithAttributedString:attributedString];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == kSenderSection) {
        return NSLocalizedString(@"confirm.payment.sender.section.title", nil);
    }

    if (section == kReceiverSection) {
        return NSLocalizedString(@"confirm.payment.receiver.section.title", nil);
    }

    return nil;
}

@end
