//
//  SignUpViewController.m
//  Transfer
//
//  Created by Henri Mägi on 24.04.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "SignUpViewController.h"
#import "UIColor+Theme.h"
#import "TableHeaderView.h"
#import "UIView+Loading.h"
#import "TextEntryCell.h"
#import "NSString+Validation.h"
#import "NSMutableString+Issues.h"
#import "UIApplication+Keyboard.h"
#import "TRWAlertView.h"
#import "TRWProgressHUD.h"
#import "RegisterOperation.h"
#import "OpenIDViewController.h"

static NSUInteger const kTableRowEmail = 0;

@interface SignUpViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIButton *singUpButton;
@property (nonatomic, strong) TextEntryCell *emailCell;
@property (nonatomic, strong) TextEntryCell *passwordCell;
@property (nonatomic, strong) TextEntryCell *passwordAgainCell;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;

- (IBAction)signUpPressed:(id)sender;
- (IBAction)googleSignUpPressed:(id)sender;
- (IBAction)yahooSignUpPressed:(id)sender;

@end

@implementation SignUpViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithNibName:@"SignUpViewController" bundle:nil];
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
    [header setMessage:NSLocalizedString(@"singup.controller.header.message", nil)];
    [self.tableView setTableHeaderView:header];

    [self.tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];

    NSMutableArray *cells = [NSMutableArray arrayWithCapacity:3];

    TextEntryCell *email = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setEmailCell:email];
    [email configureWithTitle:NSLocalizedString(@"singup.email.field.title", nil) value:@""];
    [email.entryField setReturnKeyType:UIReturnKeyNext];
    [email.entryField setKeyboardType:UIKeyboardTypeEmailAddress];
    [cells addObject:email];

    TextEntryCell *password = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setPasswordCell:password];
    [password configureWithTitle:NSLocalizedString(@"singup.password.field.title", nil) value:@""];
    [password.entryField setReturnKeyType:UIReturnKeyDone];
    [password.entryField setSecureTextEntry:YES];
    [cells addObject:password];

    TextEntryCell *passwordAgain = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setPasswordAgainCell:passwordAgain];
    [passwordAgain configureWithTitle:NSLocalizedString(@"singup.password.again.field.title", nil) value:@""];
    [passwordAgain.entryField setReturnKeyType:UIReturnKeyDone];
    [passwordAgain.entryField setSecureTextEntry:YES];
    [cells addObject:passwordAgain];

    [self.singUpButton setTitle:NSLocalizedString(@"singup.button.title.log.in", nil) forState:UIControlStateNormal];

    [self.navigationItem setTitle:NSLocalizedString(@"sign.up.controller.title", nil)];

    [self setPresentedSectionCells:@[cells]];

    [self.tableView setTableFooterView:self.footerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpPressed:(id)sender {
    [UIApplication dismissKeyboard];

    NSString *issues = [self validateInput];

    if ([issues hasValue]) {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"signup.error.title", nil) message:issues];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"sign.up.controller.creating.message", nil)];
    RegisterOperation *operation = [RegisterOperation operationWithEmail:self.emailCell.value password:self.passwordCell.value];
    [self setExecutedOperation:operation];
    [operation setCompletionHandler:^(NSError *error) {
        [hud hide];

        if (error) {
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"sign.up.controller.signup.error.message", nil) error:error];
            [alertView show];
            return;
        }

        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];

    [operation execute];
}

- (NSString *)validateInput {
    NSString *email = self.emailCell.value;
    NSString *passwordOne = self.passwordCell.value;
    NSString *passwordTwo = self.passwordAgainCell.value;

    NSMutableString *issues = [NSMutableString string];

    if (![email hasValue]) {
        [issues appendIssue:NSLocalizedString(@"sign.up.controller.validation.email.missing", nil)];
    }

    if (![email isValidEmail]) {
        [issues appendIssue:NSLocalizedString(@"sign.up.controller.validation.email.invalid", nil)];
    }

    if (![passwordOne hasValue] || ![passwordTwo hasValue]) {
        [issues appendIssue:NSLocalizedString(@"sign.up.controller.validation.password.missing", nil)];
    }

    if ([passwordOne hasValue] && [passwordTwo hasValue] && ![passwordOne isEqualToString:passwordTwo]) {
        [issues appendIssue:NSLocalizedString(@"sign.up.controller.validation.passwords.dont.match", nil)];
    }

    return [NSString stringWithString:issues];
}

- (IBAction)googleSignUpPressed:(id)sender {
    [self presentOpenIDSignUpWithProvider:@"google" name:@"Google"];
}

- (IBAction)yahooSignUpPressed:(id)sender {
    [self presentOpenIDSignUpWithProvider:@"yahoo" name:@"Yahoo"];
}

- (void)presentOpenIDSignUpWithProvider:(NSString *)provider name:(NSString *)providerName {
    OpenIDViewController *controller = [[OpenIDViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [controller setProvider:provider];
    [controller setEmail:self.emailCell.value];
    [controller setProviderName:providerName];
    [controller setRegisterUser:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
