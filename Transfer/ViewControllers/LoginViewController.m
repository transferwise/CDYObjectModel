//
//  LoginViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+Theme.h"
#import "TableHeaderView.h"
#import "UIView+Loading.h"
#import "TextEntryCell.h"
#import "NSString+Validation.h"
#import "NSMutableString+Issues.h"
#import "UIApplication+Keyboard.h"
#import "TRWAlertView.h"
#import "TRWProgressHUD.h"
#import "LoginOperation.h"
#import "NSError+TRWErrors.h"
#import "OpenIDViewController.h"
#import "TransferBackButtonItem.h"
#import "GoogleAnalytics.h"

static NSUInteger const kTableRowEmail = 0;

@interface LoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIView *footerView;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet TextEntryCell *emailCell;
@property (nonatomic, strong) IBOutlet TextEntryCell *passwordCell;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, strong) IBOutlet UILabel *footerMessageLabel;

- (IBAction)loginPressed:(id)sender;
- (IBAction)googleLogInPressed:(id)sender;
- (IBAction)yahooLogInPressed:(id)sender;

@end

@implementation LoginViewController

- (id)init {
    self = [super initWithNibName:@"LoginViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];

    TableHeaderView *header = [TableHeaderView loadInstance];
    [header setMessage:NSLocalizedString(@"login.controller.header.message", nil)];
    [self.tableView setTableHeaderView:header];

    [self.tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];

    TextEntryCell *email = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setEmailCell:email];
    [email configureWithTitle:NSLocalizedString(@"login.email.field.title", nil) value:@""];
    [email.entryField setDelegate:self];
    [email.entryField setReturnKeyType:UIReturnKeyNext];
    [email.entryField setKeyboardType:UIKeyboardTypeEmailAddress];

    TextEntryCell *password = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setPasswordCell:password];
    [password configureWithTitle:NSLocalizedString(@"login.password.field.title", nil) value:@""];
    [password.entryField setDelegate:self];
    [password.entryField setReturnKeyType:UIReturnKeyDone];
    [password.entryField setSecureTextEntry:YES];

    [self.loginButton setTitle:NSLocalizedString(@"button.title.log.in", nil) forState:UIControlStateNormal];

    [self.footerMessageLabel setText:NSLocalizedString(@"login.controller.footer.message", nil)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [self.navigationItem setTitle:NSLocalizedString(@"login.controller.title", nil)];

    [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController]];

    [[GoogleAnalytics sharedInstance] sendScreen:@"Login"];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == kTableRowEmail) {
        return self.emailCell;
    } else {
        return self.passwordCell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == kTableRowEmail) {
        [self.emailCell.entryField becomeFirstResponder];
    } else {
        [self.passwordCell.entryField becomeFirstResponder];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGRectGetHeight(self.footerView.frame);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailCell.entryField) {
        [self.passwordCell.entryField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }

    return YES;
}

- (IBAction)loginPressed:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self validateInputAndPerformLogin];
    });
}

- (void)validateInputAndPerformLogin {
    [UIApplication dismissKeyboard];

    NSString *issues = [self validateInput];
    if ([issues length] > 0) {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"login.error.title", nil) message:issues];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"login.controller.logging.in.message", nil)];

    LoginOperation *loginOperation = [LoginOperation loginOperationWithEmail:[self.emailCell value] password:[self.passwordCell value]];
    [self setExecutedOperation:loginOperation];

    [loginOperation setObjectModel:self.objectModel];

    [loginOperation setResponseHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];

            if (!error) {
                [[GoogleAnalytics sharedInstance] sendAppEvent:@"UserLogged" withLabel:@"tw"];
                [self dismissViewControllerAnimated:YES completion:nil];
                return;
            }

            TRWAlertView *alertView;
            if ([error isTransferwiseError]) {
                NSString *message = [error localizedTransferwiseMessage];
                [[GoogleAnalytics sharedInstance] sendAlertEvent:@"LoginIncorrectCredentials" withLabel:message];
                alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"login.error.title", nil) message:message];
            } else {
                alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"login.error.title", nil)
                                                     message:NSLocalizedString(@"login.error.generic.message", nil)];
                [[GoogleAnalytics sharedInstance] sendAlertEvent:@"LoginIncorrectCredentials" withLabel:error.localizedDescription];
            }

            [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];

            [alertView show];
        });
    }];

    [loginOperation execute];
}

- (NSString *)validateInput {
    NSMutableString *issues = [NSMutableString string];

    NSString *email = [self.emailCell value];
    NSString *password = [self.passwordCell value];

    if (![email hasValue]) {
        [issues appendIssue:NSLocalizedString(@"login.validation.email.missing", nil)];
    } else if ([email hasValue] && ![email isValidEmail]) {
        [issues appendIssue:NSLocalizedString(@"login.validation.email.not.valid", nil)];
    }

    if (![password hasValue]) {
        [issues appendIssue:NSLocalizedString(@"login.validation.password.missing", nil)];
    }

    return [NSString stringWithString:issues];
}

- (IBAction)googleLogInPressed:(id)sender {
    [self presentOpenIDLogInWithProvider:@"google" name:@"Google"];
}

- (IBAction)yahooLogInPressed:(id)sender {
    [self presentOpenIDLogInWithProvider:@"yahoo" name:@"Yahoo"];
}

- (void)presentOpenIDLogInWithProvider:(NSString *)provider name:(NSString *)providerName {
    OpenIDViewController *controller = [[OpenIDViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [controller setProvider:provider];
    [controller setEmail:self.emailCell.value];
    [controller setProviderName:providerName];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
