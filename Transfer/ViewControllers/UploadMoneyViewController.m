//
//  UploadMoneyViewController.m
//  Transfer
//
//  Created by Henri Mägi on 10.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "UploadMoneyViewController.h"
#import "BlueButton.h"
#import "TextCell.h"
#import "UIColor+Theme.h"
#import "PlainBankTransfer.h"
#import "PlainProfileDetails.h"
#import "PlainPayment.h"
#import "PlainRecipientType.h"
#import "PlainRecipientTypeField.h"
#import "Constants.h"
#import "TransferwiseOperation.h"
#import "RecipientTypesOperation.h"
#import "TRWProgressHUD.h"
#import "TRWAlertView.h"
#import "UINavigationController+StackManipulations.h"
#import "Credentials.h"
#import "ClaimAccountViewController.h"

@interface UploadMoneyViewController ()

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *toggleButton;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet BlueButton *doneButton;
@property (strong, nonatomic) IBOutlet UIView *footerBottomMessageView;
@property (strong, nonatomic) PlainBankTransfer *transferDetails;

@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@end

@implementation UploadMoneyViewController

- (id)init{
    self = [super initWithNibName:@"UploadMoneyViewController" bundle:nil];
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

    [self setTitle:NSLocalizedString(@"upload.money.title", @"")];
    
    [self.headerLabel setText:NSLocalizedString(@"upload.money.header.label", @"")];
    [self.toggleButton setTitle:NSLocalizedString(@"upload.money.toggle.button.debit.card.title", @"") forSegmentAtIndex:0];
    [self.toggleButton setTitle:NSLocalizedString(@"upload.money.toggle.button.bank.transfer.title", @"") forSegmentAtIndex:1];
    [self.toggleButton setSelectedSegmentIndex:1];
    [self.toggleButton setUserInteractionEnabled:NO];
    [self.doneButton setTitle:NSLocalizedString(@"upload.money.done.button.title", @"") forState:UIControlStateNormal];

    [self.tableView registerNib:[UINib nibWithNibName:@"TextCell" bundle:nil] forCellReuseIdentifier:TWTextCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!self.recipientTypes) {
        TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
        [hud setMessage:NSLocalizedString(@"upload.money.pulling.data.message", nil)];

        RecipientTypesOperation *operation = [RecipientTypesOperation operation];
        [self setExecutedOperation:operation];
        [operation setResultHandler:^(NSArray *recipients, NSError *error) {
            [hud hide];

            if (error) {
                TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"upload.money.data.error.title", nil) error:error];
                [alertView show];;
                return;
            }

            [self setRecipientTypes:recipients];
            [self loadDataToCells];
        }];

        [operation execute];
    } else {
        [self loadDataToCells];
    }

    [self.navigationController flattenStack];
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

    PlainRecipientType *type = [self findTypeForCode:self.payment.settlementRecipient.type];
    NSArray *accountCells = [self buildAccountCellForType:type recipient:self.payment.settlementRecipient];
    [presentedCells addObjectsFromArray:accountCells];

    //TODO jaanus: bank name cell
    TextCell *referenceCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
    [referenceCell configureWithTitle:NSLocalizedString(@"upload.money.reference.title", nil) text:self.userDetails.reference];
    [presentedCells addObject:referenceCell];

    TextCell *addressCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
    [addressCell configureWithTitle:NSLocalizedString(@"upload.money.address.title", nil) text:NSLocalizedString(@"upload.money.our.address.label", @"")];
    [presentedCells addObject:addressCell];
    CGRect addressFrame = addressCell.frame;
    //TODO jaanus: calculate actual height
    addressFrame.size.height = 80;
    [addressCell setFrame:addressFrame];

    [self setPresentedSectionCells:@[presentedCells]];

    [self.tableView reloadData];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    [self adjustFooterView];
}

- (NSArray *)buildAccountCellForType:(PlainRecipientType *)type recipient:(PlainRecipient *)recipient {
    NSMutableArray *result = [NSMutableArray array];
    for (PlainRecipientTypeField *field in type.fields) {
        TextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
        [cell configureWithTitle:field.title text:[recipient valueForKeyPath:field.name]];
        [result addObject:cell];
    }
    return result;
}

- (PlainRecipientType *)findTypeForCode:(NSString *)code {
    for (PlainRecipientType *type in self.recipientTypes) {
        if ([type.type isEqualToString:code]) {
            return type;
        }
    }

    return nil;
}

- (void)adjustFooterView {
    CGFloat sizeDiff = self.tableView.frame.size.height - self.tableView.contentSize.height;
    if (sizeDiff > 0) {
        CGRect footerFrame = self.footerView.frame;
        footerFrame.size.height += sizeDiff;
        self.footerView.frame = footerFrame;

        //Where from is the 20?
        CGRect footerBottomMessageFrame = self.footerBottomMessageView.frame;
        footerBottomMessageFrame.origin.y = footerFrame.size.height - footerBottomMessageFrame.size.height + 20;
        self.footerBottomMessageView.frame = footerBottomMessageFrame;

        [self.tableView setScrollEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneBtnClicked:(id)sender {
    if ([Credentials temporaryAccount]) {
        ClaimAccountViewController *controller = [[ClaimAccountViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
    }
}

- (IBAction)toggleButtonValueChanged:(id)sender {

}

- (void)viewDidUnload {
    [self setHeaderView:nil];
    [self setFooterView:nil];
    [self setToggleButton:nil];
    [self setHeaderLabel:nil];
    [self setDoneButton:nil];
    [self setFooterBottomMessageView:nil];
    [super viewDidUnload];
}

@end
