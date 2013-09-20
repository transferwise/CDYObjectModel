//
//  BusinessProfileIdentificationViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 9/20/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "BusinessProfileIdentificationViewController.h"
#import "TextContainerView.h"
#import "UIColor+Theme.h"
#import "UITableView+FooterPositioning.h"
#import "TransferBackButtonItem.h"
#import "BlueButton.h"
#import "ConfirmPaymentCell.h"
#import "GrayButton.h"

@interface BusinessProfileIdentificationViewController ()

@property (nonatomic, strong) IBOutlet TextContainerView *headerView;
@property (nonatomic, strong) IBOutlet TextContainerView *footerView;
@property (nonatomic, strong) IBOutlet BlueButton *sentButton;
@property (nonatomic, strong) IBOutlet GrayButton *skipButton;

@end

@implementation BusinessProfileIdentificationViewController

- (id)init {
    self = [super initWithNibName:@"BusinessProfileIdentificationViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];

    [self.headerView adjustHeight];
    [self.footerView adjustHeight];

    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView setTableFooterView:self.footerView];

    [self.tableView registerNib:[UINib nibWithNibName:@"ConfirmPaymentCell" bundle:nil] forCellReuseIdentifier:TWConfirmPaymentCellIdentifier];

    [self.sentButton setTitle:NSLocalizedString(@"business.profile.identification.sent.button.title", nil) forState:UIControlStateNormal];
    [self.skipButton setTitle:NSLocalizedString(@"business.profile.identification.skip.button.title", nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setTitle:NSLocalizedString(@"business.profile.identification.controller.title", nil)];

    [self.tableView adjustFooterViewSize];
    [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonWithTapHandler:^{
        [self.navigationController popViewControllerAnimated:YES];
    }]];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConfirmPaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:TWConfirmPaymentCellIdentifier];

    [cell.textLabel setText:NSLocalizedString(@"business.profile.identification.sent.documents.cell.title", nil)];
    [cell.detailTextLabel setText:@""];

    return cell;
}

@end
