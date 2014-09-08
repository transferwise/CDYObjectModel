//
//  SignUpViewController.m
//  Transfer
//
//  Created by Henri Mägi on 24.04.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <OHAttributedLabel/NSAttributedString+Attributes.h>
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
#import "LoginViewController.h"
#import "GoogleAnalytics.h"


@interface SignUpViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIButton *singUpButton;
@property (nonatomic, strong) TextEntryCell *emailCell;
@property (nonatomic, strong) TextEntryCell *passwordCell;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *googleSignupMessageLabel;
@property (nonatomic, strong) IBOutlet UILabel *passwordMessageLabel;
@property (nonatomic, strong) IBOutlet UILabel *existingUserActionLabel;

- (IBAction)signUpPressed:(id)sender;
- (IBAction)googleSignUpPressed:(id)sender;

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

    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LandingBackground"]]];

    [self.tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];

    NSMutableArray *cells = [NSMutableArray arrayWithCapacity:3];

    TextEntryCell *email = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setEmailCell:email];
    [email configureWithTitle:NSLocalizedString(@"sign.up.email.field.title", nil) value:@""];
    [email.entryField setReturnKeyType:UIReturnKeyNext];
    [email.entryField setKeyboardType:UIKeyboardTypeEmailAddress];
    [cells addObject:email];

    TextEntryCell *password = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setPasswordCell:password];
    [password configureWithTitle:NSLocalizedString(@"sign.up.password.field.title", nil) value:@""];
    [password.entryField setReturnKeyType:UIReturnKeyDone];
    [password.entryField setSecureTextEntry:YES];
    [cells addObject:password];

    [self.singUpButton setTitle:NSLocalizedString(@"sign.up.button.title.log.in", nil) forState:UIControlStateNormal];

    [self.googleSignupMessageLabel setText:NSLocalizedString(@"sign.up.controller.google.signup.message", nil)];
    [self.passwordMessageLabel setText:NSLocalizedString(@"sign.up.controller.set.password.message", nil)];
    [self.existingUserActionLabel setAttributedText:[self existingUserMessage]];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginPressed)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [self.existingUserActionLabel addGestureRecognizer:tapGestureRecognizer];

    [self setPresentedSectionCells:@[cells]];

    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView setTableFooterView:self.footerView];
}

- (NSAttributedString *)existingUserMessage {
    NSString *existingUserMessage = NSLocalizedString(@"sign.up.controller.existing.user.message", nil);
    NSString *existingUserAction = NSLocalizedString(@"sign.up.controller.existing.user.action", nil);
    NSString *baseMessage = [NSString stringWithFormat:@"%@ %@", existingUserMessage, existingUserAction];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:baseMessage];

    [result setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0, [baseMessage length])];

    NSRange actionRange = [baseMessage rangeOfString:existingUserAction];
    [result setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: HEXCOLOR(0x157EFBFF)} range:actionRange];

    return [NSAttributedString attributedStringWithAttributedString:result];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationItem setHidesBackButton:YES];

    [[GoogleAnalytics sharedInstance] sendScreen:@"Start screen register"];
}


- (IBAction)signUpPressed:(id)sender {
    [UIApplication dismissKeyboard];

    NSString *issues = [self validateInput];

    if ([issues hasValue]) {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"sign.up.error.title", nil) message:issues];
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

        [[GoogleAnalytics sharedInstance] sendAppEvent:@"UserRegistered" withLabel:@"tw"];
        [[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentViewNotification object:nil];
    }];

    [operation execute];
}

- (NSString *)validateInput {
    NSString *email = self.emailCell.value;
    NSString *passwordOne = self.passwordCell.value;

    NSMutableString *issues = [NSMutableString string];

    if (![email hasValue]) {
        [issues appendIssue:NSLocalizedString(@"sign.up.controller.validation.email.missing", nil)];
    }

    if ([email hasValue] && ![email isValidEmail]) {
        [issues appendIssue:NSLocalizedString(@"sign.up.controller.validation.email.invalid", nil)];
    }

    if (![passwordOne hasValue]) {
        [issues appendIssue:NSLocalizedString(@"sign.up.controller.validation.password.missing", nil)];
    }

    return [NSString stringWithString:issues];
}

- (IBAction)googleSignUpPressed:(id)sender {
    [self presentOpenIDSignUpWithProvider:@"google" name:@"Google"];
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

- (void)loginPressed {
    LoginViewController *controller = [[LoginViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
