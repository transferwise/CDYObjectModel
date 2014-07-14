//
//  BankTransferViewController.m
//  Transfer
//
//  Created by Henri Mägi on 10.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "BankTransferViewController.h"
#import "GreenButton.h"
#import "TextCell.h"
#import "UIColor+Theme.h"
#import "Payment.h"
#import "Currency.h"
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
#import "BankTransferDetailCell.h"
#import "SupportCoordinator.h"
#import "GoogleAnalytics.h"
#import "ObjectModel+Payments.h"
#import "MOMStyle.h"

@interface BankTransferViewController ()

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIView *footerBottomMessageView;
@property (nonatomic, strong) IBOutlet UIView *contactSupportFooter;
@property (nonatomic, strong) IBOutlet UIButton *contactSupportFooterButton;
@property (strong, nonatomic) IBOutletCollection(GreenButton) NSArray *doneButtons;

@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;

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

    
    for(UIButton *button in self.doneButtons)
    {
        [button setTitle:NSLocalizedString(@"upload.money.done.button.title", @"") forState:UIControlStateNormal];
    }

    [self.tableView registerNib:[UINib nibWithNibName:@"BankTransferDetailCell" bundle:nil] forCellReuseIdentifier:BankTransferDetailCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
    
}

- (void)loadData {
    MCLog(@"loadDataToCells");
    
    NSString *exactlyString = NSLocalizedString(@"upload.money.header.label.exactly", @"");
    exactlyString = [NSString stringWithFormat:exactlyString,self.payment.payInWithCurrency];
    
    NSString* currencyCode = self.payment.sourceCurrency.code;
    NSString* headerFormat;
    if ([currencyCode caseInsensitiveCompare:@"GBP"]==NSOrderedSame)
    {
        headerFormat = NSLocalizedString(@"upload.money.header.label.GBP", @"");
    }
    else if ([currencyCode caseInsensitiveCompare:@"EUR"]==NSOrderedSame)
    {
        headerFormat = NSLocalizedString(@"upload.money.header.label.EUR", @"");
    }
    else
    {
        headerFormat = NSLocalizedString(@"upload.money.header.label", @"");
    }
    
    NSString *text = [NSString stringWithFormat:headerFormat,exactlyString];
    NSRange exactlyRange = [text rangeOfString:exactlyString];
    
    NSMutableAttributedString *finalText = [[NSMutableAttributedString alloc] initWithString:text];
    [finalText addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromStyle:@"DarkFont"] range:exactlyRange];
    
    [self.headerLabel setAttributedText:finalText];
    [self.headerView setNeedsLayout];
    [self.headerView layoutIfNeeded];
    
    CGFloat height = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = self.headerView.frame;
    
    frame.size.height = height;
    self.headerView.frame = frame;
    
    self.tableView.tableHeaderView = self.headerView;

    
    NSMutableArray *presentedCells = [NSMutableArray array];

//    BankTransferDetailCell *amountCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
//    amountCell.headerLabel.text = NSLocalizedString(@"upload.money.amount.title", nil);
//    amountCell.valueLabel.text = self.payment.payInWithCurrency;
//    [presentedCells addObject:amountCell];

    BankTransferDetailCell *toCell = [self.tableView dequeueReusableCellWithIdentifier:BankTransferDetailCellIdentifier];
    toCell.headerLabel.text =NSLocalizedString(@"upload.money.to.title", nil);
    toCell.valueLabel.text =self.payment.settlementRecipient.name;
    [presentedCells addObject:toCell];

    RecipientType *type = self.payment.settlementRecipient.type;
    NSArray *accountCells = [self buildAccountCellForType:type recipient:self.payment.settlementRecipient];
    [presentedCells addObjectsFromArray:accountCells];

    //TODO jaanus: bank name cell
    BankTransferDetailCell *referenceCell = [self.tableView dequeueReusableCellWithIdentifier:BankTransferDetailCellIdentifier];
    referenceCell.headerLabel.text = NSLocalizedString(@"upload.money.reference.title", nil);
    referenceCell.valueLabel.text =self.objectModel.currentUser.pReference;
    [presentedCells addObject:referenceCell];

    BankTransferDetailCell *addressCell = [self.tableView dequeueReusableCellWithIdentifier:BankTransferDetailCellIdentifier];
    addressCell.headerLabel.text = NSLocalizedString(@"upload.money.address.title", nil);
    addressCell.valueLabel.text = NSLocalizedString(@"upload.money.our.address.label", @"");
    CGRect addressFrame = addressCell.frame;
    CGRect valueFrame = addressCell.valueLabel.frame;
    CGFloat heightBefore = addressCell.valueLabel.frame.size.height;
    [addressCell.valueLabel sizeToFit];
    addressFrame.size.height = addressFrame.size.height - heightBefore + addressCell.valueLabel.frame.size.height;
    addressCell.valueLabel.frame = valueFrame;
    [addressCell setFrame:addressFrame];
    
    [presentedCells addObject:addressCell];


    [self setPresentedSectionCells:@[presentedCells]];

    [self.tableView reloadData];
    [self.tableView setTableHeaderView:self.headerView];
    
    [self.tableView layoutIfNeeded];
    self.tableHeightConstraint.constant = self.tableView.contentSize.height;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.tableView adjustFooterViewSize];
}

- (NSArray *)buildAccountCellForType:(RecipientType *)type recipient:(Recipient *)recipient {
    NSMutableArray *result = [NSMutableArray array];
    for (RecipientTypeField *field in type.fields) {
        BankTransferDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BankTransferDetailCellIdentifier];
        cell.headerLabel.text = field.title;
        cell.valueLabel.text = [recipient valueField:field];
        [result addObject:cell];
    }
    return result;
}

- (IBAction)doneBtnClicked:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self.objectModel performBlock:^{
        [weakSelf.objectModel togglePaymentMadeForPayment:weakSelf.payment];
    }];
    [[GoogleAnalytics sharedInstance] sendEvent:@"PaymentMade" category:@"payment" label:@"BankTransfer"];
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

