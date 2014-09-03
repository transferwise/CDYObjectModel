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
#import "PlainPresentationCell.h"
#import "SupportCoordinator.h"
#import "GoogleAnalytics.h"
#import "ObjectModel+Payments.h"
#import "MOMStyle.h"
#import "CancelHelper.h"
#import "PayInMethod.h"
#import "TransferWaitingViewController.h"
#import "UIViewController+SwitchToViewController.h"

@interface BankTransferViewController ()

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIView *footerBottomMessageView;
@property (nonatomic, strong) IBOutlet UIView *contactSupportFooter;
@property (nonatomic, strong) IBOutlet UIButton *contactSupportFooterButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic,weak) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

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
    [self.cancelButton setTitle:NSLocalizedString(@"upload.money.cancel.button.title", @"") forState:UIControlStateNormal];

    [self.tableView registerNib:[UINib nibWithNibName:@"PlainPresentationCell" bundle:nil] forCellReuseIdentifier:PlainPresentationCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadData {
    MCLog(@"loadData");
    
    
    NSOrderedSet *payInMethodTypes = [self.payment.enabledPayInMethods valueForKey:@"type"];
    NSUInteger indexOfPaymentType= [payInMethodTypes indexOfObject:@"REGULAR"];
    
    PayInMethod* method = self.payment.enabledPayInMethods[indexOfPaymentType];
    
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
    
    self.addressLabel.text = [NSString stringWithFormat:NSLocalizedString(@"upload.money.our.address.label", @""),method.transferWiseAddress];
    [self.footerView setNeedsLayout];
    [self.footerView layoutIfNeeded];
    height = [self.footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    frame = self.footerView.frame;
    frame.size.height = height;
    self.footerView.frame = frame;

    
    //Cells

    
    NSMutableArray *presentedCells = [NSMutableArray array];
    
    PlainPresentationCell *toCell = [self.tableView dequeueReusableCellWithIdentifier:PlainPresentationCellIdentifier];
    [toCell configureWithTitle:[self addColon:NSLocalizedString(@"upload.money.to.title", nil)] text:method.recipient.name];
    [presentedCells addObject:toCell];

    RecipientType *type = method.recipient.type;
    NSArray *accountCells = [self buildAccountCellForType:type recipient:method.recipient];
    [presentedCells addObjectsFromArray:accountCells];

    PlainPresentationCell *referenceCell = [self.tableView dequeueReusableCellWithIdentifier:PlainPresentationCellIdentifier];
    [referenceCell configureWithTitle: [self addColon:NSLocalizedString(@"upload.money.reference.title", nil)] text:method.paymentReference];
    [presentedCells addObject:referenceCell];

    if ([currencyCode caseInsensitiveCompare:@"EUR"]==NSOrderedSame)
    {
        PlainPresentationCell *euroInfoCell = [self.tableView dequeueReusableCellWithIdentifier:
                                PlainPresentationCellIdentifier];
        euroInfoCell.headerLabel.numberOfLines=0; // Allow multiline
        [euroInfoCell configureWithTitle:NSLocalizedString(@"upload.money.info.label.EUR",nil) text:nil];
        CGRect infoFrame = euroInfoCell.frame;
        CGRect headerFrame = euroInfoCell.headerLabel.frame;
        [euroInfoCell.headerLabel sizeToFit];
        headerFrame.size.height = euroInfoCell.headerLabel.frame.size.height;
        infoFrame.size.height = headerFrame.origin.y + headerFrame.size.height + 0.0f;
        [euroInfoCell setFrame:infoFrame];
        euroInfoCell.headerLabel.frame = headerFrame;
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
        PlainPresentationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:PlainPresentationCellIdentifier];
        [cell configureWithTitle:[self addColon:field.title] text:[recipient valueField:field]];
        [result addObject:cell];
    }
    return result;
}

- (IBAction)doneBtnClicked:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [self.objectModel performBlock:^{
        [weakSelf.objectModel togglePaymentMadeForPayment:weakSelf.payment];
    }];
    [[GoogleAnalytics sharedInstance] sendEvent:@"PaymentMade" category:@"payment" label:@"BankTransfer"];
    if ([Credentials temporaryAccount])
	{
        ClaimAccountViewController *controller = [[ClaimAccountViewController alloc] init];
        [controller setObjectModel:self.objectModel];
        [self.navigationController pushViewController:controller animated:YES];
    }
	else
	{
		if (IPAD)
		{
			[[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
		}
		else
		{
			TransferWaitingViewController *controller = [[TransferWaitingViewController alloc] init];
			controller.payment = self.payment;
			controller.objectModel = self.objectModel;
			
			[self switchToViewController:controller];
		}
    }
}

- (IBAction)contactSupportPressed {
    NSString *subject = [NSString stringWithFormat:NSLocalizedString(@"support.email.payment.subject.base", nil), self.payment.remoteId];
    [[SupportCoordinator sharedInstance] presentOnController:self emailSubject:subject];
}

- (IBAction)cancel:(UIButton*)sender
{
    [CancelHelper cancelPayment:self.payment host:self objectModel:self.objectModel cancelBlock:^(NSError *error) {
        if(!error)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TRWMoveToPaymentsListNotification" object:nil];
        }
    } dontCancelBlock:nil];
}

-(NSString*)addColon:(NSString*)original
{
    return [original stringByAppendingString:@":"];
}
@end

