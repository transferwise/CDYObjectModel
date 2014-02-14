//
//  BankTransferViewController.m
//  Transfer
//
//  Created by Henri Mägi on 10.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "BankTransferViewController.h"
#import "BlueButton.h"
#import "TextCell.h"
#import "UIColor+Theme.h"
#import "Payment.h"
#import "Constants.h"
#import "TransferwiseOperation.h"
#import "ObjectModel.h"
#import "Credentials.h"
#import "ClaimAccountViewController.h"
#import "ObjectModel+RecipientTypes.h"
#import "RecipientType.h"
#import "Recipient.h"
#import "RecipientTypeField.h"
#import "ObjectModel+Users.h"
#import "User.h"
#import "UITableView+FooterPositioning.h"
#import "ConfirmPaymentCell.h"
#import "SupportCoordinator.h"
#import "GoogleAnalytics.h"

@interface BankTransferViewController ()

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet BlueButton *doneButton;
@property (strong, nonatomic) IBOutlet UIView *footerBottomMessageView;
@property (nonatomic, strong) IBOutlet UIView *contactSupportFooter;
@property (nonatomic, strong) IBOutlet UIButton *contactSupportFooterButton;

@property (nonatomic, strong) TransferwiseOperation *executedOperation;

- (IBAction)contactSupportPressed;

@end

@implementation BankTransferViewController

- (id)init {
    self = [super initWithNibName:@"BankTransferViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];

    [self.headerLabel setText:NSLocalizedString(@"upload.money.header.label", @"")];
    [self.doneButton setTitle:NSLocalizedString(@"upload.money.done.button.title", @"") forState:UIControlStateNormal];

    [self.tableView registerNib:[UINib nibWithNibName:@"TextCell" bundle:nil] forCellReuseIdentifier:TWTextCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ConfirmPaymentCell" bundle:nil] forCellReuseIdentifier:TWConfirmPaymentCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self loadDataToCells];
}

- (void)loadDataToCells {
    MCLog(@"loadDataToCells");
    NSMutableArray *presentedCells = [NSMutableArray array];

    TextCell *amountCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
    [amountCell configureWithTitle:NSLocalizedString(@"upload.money.amount.title", nil) text:self.payment.payInWithCurrency];
    [presentedCells addObject:amountCell];

    TextCell *toCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
    [toCell configureWithTitle:NSLocalizedString(@"upload.money.to.title", nil) text:self.payment.settlementRecipient.name];
    [presentedCells addObject:toCell];

    RecipientType *type = self.payment.settlementRecipient.type;
    NSArray *accountCells = [self buildAccountCellForType:type recipient:self.payment.settlementRecipient];
    [presentedCells addObjectsFromArray:accountCells];

    //TODO jaanus: bank name cell
    TextCell *referenceCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
    [referenceCell configureWithTitle:NSLocalizedString(@"upload.money.reference.title", nil) text:self.objectModel.currentUser.pReference];
    [presentedCells addObject:referenceCell];

    TextCell *addressCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
    [addressCell configureWithTitle:NSLocalizedString(@"upload.money.address.title", nil) text:NSLocalizedString(@"upload.money.our.address.label", @"")];
    [presentedCells addObject:addressCell];
    CGRect addressFrame = addressCell.frame;
    //TODO jaanus: calculate actual height
    addressFrame.size.height = 80;
    [addressCell setFrame:addressFrame];

    if (self.showContactSupportCell) {
        [self.contactSupportFooterButton setTitle:NSLocalizedString(@"support.contact.cell.label", nil) forState:UIControlStateNormal];
        [self.tableView setTableFooterView:self.contactSupportFooter];
    }

    [self setPresentedSectionCells:@[presentedCells]];

    [self.tableView reloadData];
    [self.tableView setTableHeaderView:self.headerView];

    if (!self.hideBottomButton) {
        [self.tableView setTableFooterView:self.footerView];
        [self.tableView adjustFooterViewSize];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.tableView adjustFooterViewSize];
}

- (NSArray *)buildAccountCellForType:(RecipientType *)type recipient:(Recipient *)recipient {
    NSMutableArray *result = [NSMutableArray array];
    for (RecipientTypeField *field in type.fields) {
        TextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
        [cell configureWithTitle:field.title text:[recipient valueField:field]];
        [result addObject:cell];
    }
    return result;
}

- (IBAction)doneBtnClicked:(id)sender {
    [[GoogleAnalytics sharedInstance] sendEvent:@"PaymentCreated" category:@"payment" label:@"BankTransfer"];
    if ([Credentials temporaryAccount]) {
        ClaimAccountViewController *controller = [[ClaimAccountViewController alloc] init];
        [controller setObjectModel:self.objectModel];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
    }
}


- (IBAction)contactSupportPressed {
    NSString *subject = [NSString stringWithFormat:NSLocalizedString(@"support.email.payment.subject.base", nil), self.payment.remoteId];
    [[SupportCoordinator sharedInstance] presentOnController:self emailSubject:subject];
}

@end
