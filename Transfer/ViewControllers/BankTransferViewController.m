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
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic,weak) IBOutlet UILabel *addressLabel;

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

    
    [self.doneButton setTitle:NSLocalizedString(@"upload.money.done.button.title", @"") forState:UIControlStateNormal];
    
    [self.contactSupportFooterButton setTitle:NSLocalizedString(@"transferdetails.controller.button.support", @"") forState:UIControlStateNormal];

    [self.tableView registerNib:[UINib nibWithNibName:@"BankTransferDetailCell" bundle:nil] forCellReuseIdentifier:BankTransferDetailCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
    
}

- (void)loadData {
    MCLog(@"loadData");
    
    
    //Header
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
    
    //Footer
    
    self.addressLabel.text = NSLocalizedString(@"upload.money.our.address.label", @"");
    [self.footerView setNeedsLayout];
    [self.footerView layoutIfNeeded];
    height = [self.footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    frame = self.footerView.frame;
    frame.size.height = height;
    self.footerView.frame = frame;

    
    //Cells

    
    NSMutableArray *presentedCells = [NSMutableArray array];

    BankTransferDetailCell *toCell = [self.tableView dequeueReusableCellWithIdentifier:BankTransferDetailCellIdentifier];
    [toCell configureWithTitle:NSLocalizedString(@"upload.money.to.title", nil) text:self.payment.settlementRecipient.name];
    [presentedCells addObject:toCell];

    RecipientType *type = self.payment.settlementRecipient.type;
    NSArray *accountCells = [self buildAccountCellForType:type recipient:self.payment.settlementRecipient];
    [presentedCells addObjectsFromArray:accountCells];

    //TODO jaanus: bank name cell
    BankTransferDetailCell *referenceCell = [self.tableView dequeueReusableCellWithIdentifier:BankTransferDetailCellIdentifier];
    [referenceCell configureWithTitle: NSLocalizedString(@"upload.money.reference.title", nil) text:self.objectModel.currentUser.pReference];
    [presentedCells addObject:referenceCell];

    if ([currencyCode caseInsensitiveCompare:@"EUR"]==NSOrderedSame)
    {
        BankTransferDetailCell *euroInfoCell = [self.tableView dequeueReusableCellWithIdentifier:
                                BankTransferDetailCellIdentifier];
        [euroInfoCell configureWithTitle:NSLocalizedString(@"upload.money.info.label.EUR",nil) text:nil];
        CGRect infoFrame = euroInfoCell.frame;
        CGRect headerFrame = euroInfoCell.headerLabel.frame;
        [euroInfoCell.headerLabel sizeToFit];
        headerFrame.size.height = euroInfoCell.headerLabel.frame.size.height;
        euroInfoCell.headerLabel.frame = headerFrame;
        infoFrame.size.height = headerFrame.origin.y + headerFrame.size.height + 8.0f;
        [euroInfoCell setFrame:infoFrame];
        [presentedCells addObject:euroInfoCell];
    }

    [self setPresentedSectionCells:@[presentedCells]];

    [self.tableView reloadData];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (NSArray *)buildAccountCellForType:(RecipientType *)type recipient:(Recipient *)recipient {
    NSMutableArray *result = [NSMutableArray array];
    for (RecipientTypeField *field in type.fields) {
        BankTransferDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BankTransferDetailCellIdentifier];
        [cell configureWithTitle:field.title text:[recipient valueField:field]];
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

