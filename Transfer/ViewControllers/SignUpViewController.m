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
#import "GoogleAnalytics.h"
#import "TransferBackButtonItem.h"
#import "NavigationBarCustomiser.h"
#import "AuthenticationHelper.h"
#import "MOMStyle.h"


@interface SignUpViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (nonatomic, strong) TextEntryCell *emailCell;
@property (nonatomic, strong) TextEntryCell *passwordCell;
@property (nonatomic, strong) TextEntryCell *confirmPasswordCell;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (weak, nonatomic) IBOutlet UITextView *legalezetextView;

- (IBAction)signUpPressed:(id)sender;

@end

@implementation SignUpViewController

- (id)init{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"sign.up.controller.title", nil);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];

    [self.registerButton setTitle:NSLocalizedString(@"sign.up.button.title.register", nil) forState:UIControlStateNormal];
    
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
    
    password = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setConfirmPasswordCell:password];
    [password configureWithTitle:NSLocalizedString(@"sign.up.password.confirm.field.title", nil) value:@""];
    [password.entryField setReturnKeyType:UIReturnKeyDone];
    [password.entryField setSecureTextEntry:YES];
    [cells addObject:password];


    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginPressed)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [self setPresentedSectionCells:@[cells]];
    
    if(!self.navigationItem.leftBarButtonItem)
    {
        [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController
                                                                                                           isBlue:YES]];
    }
    
    NSString* tos = NSLocalizedString(@"registration.tos", nil);
    NSString* privacy = NSLocalizedString(@"registration.privacy", nil);
    NSString* legaleze = [NSString stringWithFormat:NSLocalizedString(@"registration.legaleze", nil),tos,privacy];
    NSMutableAttributedString *attributedLegaleze = [NSMutableAttributedString attributedStringWithString:legaleze];
    NSRange wholeString = NSMakeRange(0, [legaleze length]);
    [attributedLegaleze addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromStyle:self.legalezetextView.fontStyle] range:wholeString];
    [attributedLegaleze addAttribute:NSFontAttributeName value:[UIFont fontFromStyle:self.legalezetextView.fontStyle] range:wholeString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attributedLegaleze addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:wholeString];
    NSRange tosRange = [legaleze rangeOfString:tos];
    [attributedLegaleze addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%@%@",TRWServerAddress,TRWToSUrl] range:tosRange];
    NSRange privacyRange = [legaleze rangeOfString:privacy];
    [attributedLegaleze addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%@%@",TRWServerAddress,TRWPrivacyUrl] range:privacyRange];
    self.legalezetextView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorFromStyle:@"TWElectricBlue"]};
    self.legalezetextView.attributedText = attributedLegaleze;
    
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

    [NavigationBarCustomiser setWhite];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [[GoogleAnalytics sharedInstance] sendScreen:@"Start screen register"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NavigationBarCustomiser setDefault];
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
    operation.objectModel = self.objectModel;
    [self setExecutedOperation:operation];
    [operation setCompletionHandler:^(NSError *error) {
        [hud hide];

        if (error) {
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"sign.up.controller.signup.error.message", nil) error:error];
            [alertView show];
            return;
        }

        [[GoogleAnalytics sharedInstance] sendAppEvent:@"UserRegistered" withLabel:@"tw"];
        [AuthenticationHelper proceedFromSuccessfulLoginFromViewController:self objectModel:self.objectModel];
    }];

    [operation execute];
}

- (NSString *)validateInput {
    NSString *email = self.emailCell.value;
    NSString *passwordOne = self.passwordCell.value;
    NSString *passwordTwo = self.confirmPasswordCell.value;

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
    else if (![passwordOne isEqualToString:passwordTwo]) {
        [issues appendIssue:NSLocalizedString(@"sign.up.controller.validation.password.mismatch", nil)];
    }

    return [NSString stringWithString:issues];
}

#pragma mark - TextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return YES;
}


@end
