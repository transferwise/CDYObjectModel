//
//  SettingsViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/18/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTitleCell.h"
#import "UIColor+Theme.h"
#import "Credentials.h"

NSString *const kSettingsTitleCellIdentifier = @"kSettingsTitleCellIdentifier";

typedef NS_ENUM(short, SettingsRow) {
    LogoutRow
};

@interface SettingsViewController ()

@property (nonatomic, strong) NSArray *presentedRows;

@end

@implementation SettingsViewController

- (id)init {
    self = [super initWithNibName:@"SettingsViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"SettingsTitleCell" bundle:nil] forCellReuseIdentifier:kSettingsTitleCellIdentifier];

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor settingsBackgroundColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSMutableArray *presented = [NSMutableArray array];
    if ([Credentials userLoggedIn]) {
        [presented addObject:@(LogoutRow)];
    } else {

    }

    [self setPresentedRows:presented];
    [self.tableView reloadData];

    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
    [self.navigationItem setLeftBarButtonItem:cancel];
}

- (void)cancelPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.presentedRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingsTitleCellIdentifier];

    SettingsRow code = (SettingsRow) [self.presentedRows[(NSUInteger) indexPath.row] shortValue];
    switch (code) {
        case LogoutRow:
            [cell setTitle:NSLocalizedString(@"settings.row.logout", nil)];
            break;
        default:
            [cell setTitle:@"Unknown case..."];
    }

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SettingsRow code = (SettingsRow) [self.presentedRows[(NSUInteger) indexPath.row] shortValue];
    switch (code) {
        case LogoutRow:
            [Credentials clearCredentials];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
    }
}

@end
