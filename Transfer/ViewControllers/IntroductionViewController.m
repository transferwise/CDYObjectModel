//
//  IntroductionViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "IntroductionViewController.h"
#import "TableHeaderView.h"
#import "MoneyEntryCell.h"
#import "IntroductionControlsView.h"
#import "LoginViewController.h"
#import "UIColor+Theme.h"
#import "UIView+Loading.h"

@interface IntroductionViewController ()

@property (nonatomic, strong) IBOutlet IntroductionControlsView *controlsView;

- (IBAction)loginPressed:(id)sender;

@end

@implementation IntroductionViewController

- (id)init {
    self = [super initWithNibName:@"IntroductionViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];

    [self.tableView registerNib:[UINib nibWithNibName:@"MoneyEntryCell" bundle:nil] forCellReuseIdentifier:TWMoneyEntryCellIdentifier];

    TableHeaderView *header = [TableHeaderView loadInstance];
    [header setMessage:NSLocalizedString(@"introduction.header.title.text", nil)];
    [self.tableView setTableHeaderView:header];
    [self.tableView setTableFooterView:self.controlsView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setTitle:NSLocalizedString(@"introduction.controller.title", nil)];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoneyEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:TWMoneyEntryCellIdentifier];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)loginPressed:(id)sender {
    LoginViewController *controller = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
