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
#import "ProfileDetails.h"
#import "PersonalProfile.h"
#import "Recipient.h"
#import "RecipientType.h"
#import "RecipientTypeField.h"
#import "OHAttributedLabel/OHAttributedLabel.h"
#import "CalculationResult.h"
#import "CreatePaymentOperation.h"
#import "TRWProgressHUD.h"
#import "TRWAlertView.h"
#import "Payment.h"
#import "TextEntryCell.h"
#import "NSString+Validation.h"
#import "RecipientTypesOperation.h"

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
@property (nonatomic, strong) Payment *createdPayment;

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
    [senderNameCell.imageView setImage:[UIImage imageNamed:@"ProfileIcon.png"]];
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
    NSArray *fields = self.recipientType.fields;
    NSMutableArray *cells = [NSMutableArray arrayWithCapacity:[fields count]];
    for (RecipientTypeField *field in fields) {
        ConfirmPaymentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TWConfirmPaymentCellIdentifier];
        [cell.textLabel setText:field.title];
        [cell.detailTextLabel setText:[self.recipient valueForKeyPath:field.name]];
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

    TRWActionBlock completion = ^{
        [self createContent];
        [self fillDataCells];
        [self.tableView reloadData];
    };

    if (!self.recipientType) {
        TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
        [hud setMessage:NSLocalizedString(@"confirm.payment.pulling.data", nil)];
        RecipientTypesOperation *operation = [RecipientTypesOperation operation];
        [self setExecutedOperation:operation];

        [operation setResultHandler:^(NSArray *recipients, NSError *error) {
            [hud hide];

            if (error) {
                TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"confirm.payment.data.error.title", nil) error:error];
                [alertView show];
                return;
            }

            NSArray *filtered = [recipients filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                RecipientType *type = evaluatedObject;

                return [type.type isEqualToString:self.recipient.type];
            }]];

            [self setRecipientType:[filtered lastObject]];
            completion();
        }];

        [operation execute];
    } else {
        completion();
    }
}

- (void)fillDataCells {
    [self.yourDepositValueLabel setText:[self.calculationResult transferwisePayInStringWithCurrency]];
    [self.exchangedToValueLabel setText:[self.calculationResult transferwisePayOutStringWithCurrency]];

    NSString *rateString = [NSString stringWithFormat:@"%@", self.calculationResult.transferwiseRate];
    NSString *messageString = [NSString stringWithFormat:NSLocalizedString(@"confirm.payment.estimated.exchange.rate.message", nil), rateString];
    NSAttributedString *exchangeRateString = [self attributedStringWithBase:messageString markedString:rateString];
    [self.estimatedExchangeRateLabel setAttributedText:exchangeRateString];

    NSString *dateString = self.calculationResult.paymentDateString;
    NSString *dateMessageString = [NSString stringWithFormat:NSLocalizedString(@"confirm.payment.delivery.date.message", nil), dateString];
    NSAttributedString *paymentDateString = [self attributedStringWithBase:dateMessageString markedString:dateString];
    [self.deliveryDateLabelLabel setAttributedText:paymentDateString];

    [self.senderNameCell.textLabel setText:[self.senderDetails.personalProfile fullName]];
    [self.senderNameCell.detailTextLabel setText:NSLocalizedString(@"confirm.payment.sender.marker.label", nil)];

    [self.senderEmailCell.textLabel setText:NSLocalizedString(@"confirm.payment.email.label", nil)];
    [self.senderEmailCell.detailTextLabel setText:self.senderDetails.email];

    [self.receiverNameCell.textLabel setText:[self.recipient name]];
    [self.receiverNameCell.detailTextLabel setText:NSLocalizedString(@"confirm.payment.recipient.marker.label", nil)];

    [self.receiverEmailCell setEditable:YES];
    [self.receiverEmailCell configureWithTitle:NSLocalizedString(@"confirm.payment.email.label", nil) value:[self.recipient email]];

    [self.referenceCell setEditable:YES];
    [self.referenceCell configureWithTitle:NSLocalizedString(@"confirm.payment.reference.label", nil) value:@""];
}

- (IBAction)footerButtonPressed:(id)sender {
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
    [hud setMessage:NSLocalizedString(@"confirm.payment.creating.message", nil)];
    CreatePaymentOperation *operation = [CreatePaymentOperation operation];
    [self setExecutedOperation:operation];

    [operation setRecipientId:self.recipient.recipientId];
    [operation setSourceCurrency:self.calculationResult.sourceCurrency];
    [operation setTargetCurrency:self.calculationResult.targetCurrency];
    [operation setAmount:self.calculationResult.amount];
    NSString *reference = [self.referenceCell value];
    if ([reference hasValue]) {
        [operation addReference:reference];
    }
    NSString *email = [self.receiverEmailCell value];
    if ([email hasValue]) {
        [operation setEmail:email];
    }

    [operation setResponseHandler:^(Payment *payment, NSError *error) {
        [hud hide];
        if (error) {
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"confirm.payment.payment.error.title", nil) error:error];
            [alertView show];
            return;
        }

        [self setCreatedPayment:payment];
        self.afterSaveAction();
    }];

    [operation execute];
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

@end
