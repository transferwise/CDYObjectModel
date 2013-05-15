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
#import "BankTransfer.h"
#import "ProfileDetails.h"
#import "Payment.h"
#import "RecipientType.h"
#import "RecipientTypeField.h"

@interface UploadMoneyViewController ()

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *toggleButton;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UILabel *footerLabel;
@property (strong, nonatomic) IBOutlet BlueButton *doneButton;
@property (strong, nonatomic) IBOutlet UILabel *notificationLabel;
@property (strong, nonatomic) IBOutlet UIView *footerBottomMessageView;
@property (strong, nonatomic) BankTransfer *transferDetails;

@property (strong, nonatomic) TextCell *amountCell;
@property (strong, nonatomic) TextCell *ibanCell;
@property (strong, nonatomic) TextCell *accountNrCell;
@property (strong, nonatomic) TextCell *bicCell;
@property (strong, nonatomic) TextCell *bankNameCell;
@property (strong, nonatomic) TextCell *referenceCell;
@property (strong, nonatomic) TextCell *ukSortCodeCell;

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
    [self.headerView setBackgroundColor:[UIColor controllerBackgroundColor]];
    [self.footerView setBackgroundColor:[UIColor controllerBackgroundColor]];
    
    [self setTitle:NSLocalizedString(@"upload.money.title", @"")];
    
    [self.headerLabel setText:NSLocalizedString(@"upload.money.header.label", @"")];
    [self.footerLabel setText:NSLocalizedString(@"upload.money.footer.label", @"")];
    [self.toggleButton setTitle:NSLocalizedString(@"upload.money.toggle.button.debit.card.title", @"") forSegmentAtIndex:0];
    [self.toggleButton setTitle:NSLocalizedString(@"upload.money.toggle.button.bank.transfer.title", @"") forSegmentAtIndex:1];
    [self.toggleButton setSelectedSegmentIndex:1];
    [self.toggleButton setUserInteractionEnabled:NO];
    [self.doneButton setTitle:NSLocalizedString(@"upload.money.done.button.title", @"") forState:UIControlStateNormal];
    [self.notificationLabel setText:NSLocalizedString(@"upload.money.notification.label", @"")];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TextCell" bundle:nil] forCellReuseIdentifier:TWTextCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self loadDataToCells];
}

- (void)loadDataToCells {
    NSMutableArray *presentedCells = [NSMutableArray array];

    TextCell *amountCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
    [amountCell configureWithTitle:NSLocalizedString(@"upload.money.amount.title", nil) text:self.payment.payInWithCurrency];
    [presentedCells addObject:presentedCells];

    TextCell *toCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
    [toCell configureWithTitle:NSLocalizedString(@"upload.money.to.title", nil) text:self.payment.settlementRecipient.name];
    [presentedCells addObject:toCell];

    RecipientType *type = [self findTypeForCode:self.payment.settlementRecipient.type];
    NSArray *accountCells = [self buildAccountCellForType:type recipient:self.payment.settlementRecipient];
    [presentedCells addObjectsFromArray:accountCells];

    //TODO jaanus: bank name cell
    TextCell *referenceCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
    [referenceCell configureWithTitle:NSLocalizedString(@"upload.money.reference.title", nil) text:self.userDetails.reference];
    [presentedCells addObject:referenceCell];

    [self setPresentedSectionCells:@[presentedCells]];

    [self.tableView reloadData];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    [self adjustFooterView];
}

- (NSArray *)buildAccountCellForType:(RecipientType *)type recipient:(Recipient *)recipient {
    NSMutableArray *result = [NSMutableArray array];
    for (RecipientTypeField *field in type.fields) {
        TextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
        [cell configureWithTitle:field.title text:[result valueForKeyPath:field.name]];
        [result addObject:cell];
    }
    return result;
}

- (RecipientType *)findTypeForCode:(NSString *)code {
    for (RecipientType *type in self.recipientTypes) {
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

}

- (IBAction)toggleButtonValueChanged:(id)sender {

}

- (void)viewDidUnload {
    [self setHeaderView:nil];
    [self setFooterView:nil];
    [self setToggleButton:nil];
    [self setHeaderLabel:nil];
    [self setFooterLabel:nil];
    [self setDoneButton:nil];
    [self setNotificationLabel:nil];
    [self setFooterBottomMessageView:nil];
    [super viewDidUnload];
}
@end
