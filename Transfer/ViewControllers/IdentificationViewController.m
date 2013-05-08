//
//  IdentificationViewController.m
//  Transfer
//
//  Created by Henri Mägi on 08.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "IdentificationViewController.h"
#import "UIColor+Theme.h"
#import "TextCell.h"
#import "BlueButton.h"

@interface IdentificationViewController ()

@property (strong, nonatomic) IBOutlet UIView* headerView;
@property (strong, nonatomic) IBOutlet UIView* footerView;
@property (strong, nonatomic) TextCell* idDocumentCell;
@property (strong, nonatomic) TextCell* proofOfAddressCell;
@property (strong, nonatomic) TextCell* reasonOfTransferCell;
@property (strong, nonatomic) IBOutlet UILabel *reasonTitle;
@property (strong, nonatomic) IBOutlet UILabel *excuseLabel;
@property (strong, nonatomic) IBOutlet UILabel *explanationLabel;
@property (strong, nonatomic) IBOutlet UILabel *skipLabel;
@property (strong, nonatomic) IBOutlet BlueButton *continueButton;
@property (strong, nonatomic) IBOutlet UISwitch *skipSwitch;

@property (strong, nonatomic) NSArray* presentedSectionCells;

@end

@implementation IdentificationViewController

- (id)init {
    self = [super initWithNibName:@"IdentificationViewController" bundle:nil];
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
    
    [self.reasonTitle setText:NSLocalizedString(@"identification.reason.title", @"")];
    [self.excuseLabel setText:NSLocalizedString(@"identification.excuse", @"")];
    [self.explanationLabel setText:NSLocalizedString(@"identification.explanation", @"")];
    [self.skipLabel setText:NSLocalizedString(@"identification.skip.send", @"")];
    [self.continueButton setTitle:NSLocalizedString(@"identification.upload.and.continue.button", @"") forState:UIControlStateNormal];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TextCell" bundle:nil] forCellReuseIdentifier:TWTextCellIdentifier];
    
    NSMutableArray *photoCells = [NSMutableArray array];
    
    TextCell *idDocumentCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
    [self setIdDocumentCell:idDocumentCell];
    [photoCells addObject:idDocumentCell];
    [idDocumentCell configureWithTitle:NSLocalizedString(@"identification.id.document", @"") text:NSLocalizedString(@"identification.take.photo", @"")];
    
    TextCell *proofOfAddressCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
    [self setProofOfAddressCell:proofOfAddressCell];
    [photoCells addObject:proofOfAddressCell];
    [proofOfAddressCell configureWithTitle:NSLocalizedString(@"identification.proof.of.address", @"") text:NSLocalizedString(@"identification.take.photo", @"")];
    
    NSMutableArray *reasonCells = [NSMutableArray array];
    
    TextCell *reasonOfTransferCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextCellIdentifier];
    [self setReasonOfTransferCell:reasonOfTransferCell];
    [reasonCells addObject:reasonOfTransferCell];
    [reasonOfTransferCell configureWithTitle:NSLocalizedString(@"identification.reason", @"") text:@""];
    
    [self setPresentedSectionCells:@[photoCells, reasonCells]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Take photo

- (void)dummyTakePhoto {
    
}

#pragma mark - Continue

- (IBAction)continueClicked:(id)sender {
}

- (void)viewDidUnload {
    [self setReasonTitle:nil];
    [self setExcuseLabel:nil];
    [self setExplanationLabel:nil];
    [self setSkipLabel:nil];
    [self setContinueButton:nil];
    [self setSkipSwitch:nil];
    [super viewDidUnload];
}
@end
