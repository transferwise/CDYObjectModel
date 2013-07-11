//
//  ContactsViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ContactsViewController.h"
#import "Constants.h"
#import "RecipientCell.h"
#import "UIColor+Theme.h"
#import "UserRecipientsOperation.h"
#import "TRWAlertView.h"
#import "PlainRecipient.h"
#import "TRWProgressHUD.h"
#import "RecipientViewController.h"
#import "DeleteRecipientOperation.h"
#import "PaymentViewController.h"
#import "RecipientProfileCommitter.h"

NSString *const kRecipientCellIdentifier = @"kRecipientCellIdentifier";

@interface ContactsViewController ()

@property (nonatomic, strong) NSArray *recipients;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@end

@implementation ContactsViewController

- (id)init {
    self = [super initWithNibName:@"ContactsViewController" bundle:nil];
    if (self) {
        UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"contacts.controller.title", nil) image:[UIImage imageNamed:@"ContactsTabIcon.png"] tag:0];
        [self setTabBarItem:barItem];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"RecipientCell" bundle:nil] forCellReuseIdentifier:kRecipientCellIdentifier];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshRecipients];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContactPressed)];
    [self.tabBarController.navigationItem setRightBarButtonItem:addButton];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recipients count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipientCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipientCellIdentifier];

    PlainRecipient *recipient = [self.recipients objectAtIndex:indexPath.row];
    [cell configureWithRecipient:recipient];

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    PlainRecipient *recipient = [self.recipients objectAtIndex:indexPath.row];
    PaymentViewController *controller = [[PaymentViewController alloc] init];
    [controller setRecipient:recipient];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)refreshRecipients {
    MCLog(@"refreshRecipients");
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"contacts.controller.refreshing.message", nil)];

    UserRecipientsOperation *operation = [UserRecipientsOperation recipientsOperation];
    [self setExecutedOperation:operation];

    [operation setResponseHandler:^(NSArray *recipients, NSError *error) {
        MCLog(@"Received %d recipients", [recipients count]);

        [hud hide];

        [self setExecutedOperation:nil];

        [self handleListRefreshWithRecipients:recipients error:error];
    }];

    [operation execute];
}

- (void)addContactPressed {
    RecipientViewController *controller = [[RecipientViewController alloc] init];
    [controller setTitle:NSLocalizedString(@"recipient.controller.add.mode.title", nil)];
    [controller setFooterButtonTitle:NSLocalizedString(@"recipient.controller.add.button.title", nil)];
    [controller setRecipientValidation:[[RecipientProfileCommitter alloc] init]];
    [controller setAfterSaveAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }

    PlainRecipient *recipient = [self.recipients objectAtIndex:indexPath.row];
    TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"contacts.controller.delete.conformation.title", nil)
                                                       message:[NSString stringWithFormat:NSLocalizedString(@"contacts.controller.delete.confirmation.message", nil), recipient.name]];
    [alertView setLeftButtonTitle:NSLocalizedString(@"button.title.delete", nil) rightButtonTitle:NSLocalizedString(@"button.title.cancel", nil)];

    [alertView setLeftButtonAction:^{
        [self deleteRecipient:recipient];
    }];

    [alertView show];
}

- (void)deleteRecipient:(PlainRecipient *)recipient {
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"Delete recipient:%@", recipient);
        TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
        [hud setMessage:NSLocalizedString(@"contacts.controller.deleting.message", nil)];

        DeleteRecipientOperation *operation = [DeleteRecipientOperation operationWithRecipient:recipient];
        [self setExecutedOperation:operation];
        [operation setCompletionHandler:^(NSArray *recipients, NSError *error) {
            [hud hide];
            [self handleListRefreshWithRecipients:recipients error:error];
        }];

        [operation execute];
    });
}

- (void)handleListRefreshWithRecipients:(NSArray *)recipients error:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"contacts.refresh.error.title", nil)
                                                               message:NSLocalizedString(@"contacts.refresh.error.message", nil)];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
            [alertView show];

            return;
        }

        [self setRecipients:recipients];
        [self.tableView reloadData];
    });
}

@end
