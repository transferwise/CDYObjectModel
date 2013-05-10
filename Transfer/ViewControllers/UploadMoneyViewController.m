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

@interface UploadMoneyViewController ()
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *toggleButton;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UILabel *footerLabel;
@property (strong, nonatomic) IBOutlet BlueButton *doneButton;
@property (strong, nonatomic) IBOutlet UILabel *notificationLabel;
@property (strong, nonatomic) BankTransfer *transferDetails;

@property (strong, nonatomic) TextCell *amountCell;
@property (strong, nonatomic) TextCell *ibanCell;
@property (strong, nonatomic) TextCell *accountNrCell;
@property (strong, nonatomic) TextCell *bicCell;
@property (strong, nonatomic) TextCell *bankNameCell;
@property (strong, nonatomic) TextCell *referenceCell;
@property (strong, nonatomic) TextCell *ukSortCodeCell;

@property (strong, nonatomic) NSArray* presentedSectionCells;

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
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    [self.headerLabel setText:NSLocalizedString(@"upload.money.header.label", @"")];
    [self.footerLabel setText:NSLocalizedString(@"upload.money.footer.label", @"")];
    [self.toggleButton setTitle:NSLocalizedString(@"upload.money.toggle.button.debit.card.title", @"") forSegmentAtIndex:0];
    [self.toggleButton setTitle:NSLocalizedString(@"upload.money.toggle.button.bank.transfer.title", @"") forSegmentAtIndex:1];
    [self.doneButton setTitle:NSLocalizedString(@"upload.money.done.button.title", @"") forState:UIControlStateNormal];
    [self.notificationLabel setText:NSLocalizedString(@"upload.money.notification.label", @"")];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TextCell" bundle:nil] forCellReuseIdentifier:TWTextCellIdentifier];
}

- (void)fillFieldsWithData:(BankTransfer*)data
{
    NSMutableArray *transferCells = [NSMutableArray array];
    
    TextCell *amountCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
    [self setAmountCell:amountCell];
    [transferCells addObject:amountCell];
    [amountCell configureWithTitle:NSLocalizedString(@"upload.money.amount.title", @"") text:data.amount];

    if(data.iban){
        TextCell *ibanCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
        [self setIbanCell:ibanCell];
        [transferCells addObject:ibanCell];
        [ibanCell configureWithTitle:NSLocalizedString(@"upload.money.iban.title", @"") text:data.iban];
    }
    if(data.accountNr){
        TextCell *accountNrCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
        [self setAccountNrCell:accountNrCell];
        [transferCells addObject:accountNrCell];
        [accountNrCell configureWithTitle:NSLocalizedString(@"upload.money.account.nr.title", @"") text:data.accountNr];
    }
    if(data.bic){
        TextCell *bicCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
        [self setBicCell:bicCell];
        [transferCells addObject:bicCell];
        [bicCell configureWithTitle:NSLocalizedString(@"upload.money.bic.title", @"") text:data.bic];
    }
    if(data.ukSort){
        TextCell *ukSortCodeCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
        [self setUkSortCodeCell:ukSortCodeCell];
        [transferCells addObject:ukSortCodeCell];
        [ukSortCodeCell configureWithTitle:NSLocalizedString(@"upload.money.uksort.title", @"") text:data.ukSort];
    }
    
    TextCell *bankNameCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
    [self setBankNameCell:bankNameCell];
    [transferCells addObject:bankNameCell];
    [bankNameCell configureWithTitle:NSLocalizedString(@"upload.money.bank.name.title", @"") text:data.bankName];
    
    TextCell *referenceCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
    [self setReferenceCell:referenceCell];
    [transferCells addObject:referenceCell];
    [referenceCell configureWithTitle:NSLocalizedString(@"upload.money.reference.title", @"") text:data.reference];
}

#pragma mark - UITableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.presentedSectionCells count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArray = [self.presentedSectionCells objectAtIndex:section];
    return [sectionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.presentedSectionCells[indexPath.section][indexPath.row];
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    [super viewDidUnload];
}
@end
