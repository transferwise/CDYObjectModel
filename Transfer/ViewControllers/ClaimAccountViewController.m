//
//  ClaimAccountViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 6/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ClaimAccountViewController.h"
#import "TextEntryCell.h"
#import "UIColor+Theme.h"
#import "Credentials.h"
#import "UINavigationController+StackManipulations.h"
#import "NSString+Validation.h"
#import "TRWAlertView.h"
#import "TransferwiseOperation.h"
#import "ClaimAccountOperation.h"
#import "TRWProgressHUD.h"
#import "UIApplication+Keyboard.h"
#import "TransferBackButtonItem.h"

@interface ClaimAccountViewController ()

@property (nonatomic, strong) IBOutlet TextEntryCell *emailCell;
@property (nonatomic, strong) IBOutlet TextEntryCell *passwordCell;
@property (nonatomic, strong) IBOutlet UIView *footerView;
@property (nonatomic, strong) IBOutlet UIButton *footerButton;
@property (nonatomic, strong) IBOutlet UILabel *footerMessageLabel;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;

- (IBAction)footerButtonPressed:(id)sender;

@end

@implementation ClaimAccountViewController

- (id)init {
    self = [super initWithNibName:@"ClaimAccountViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];

    NSMutableArray *cells = [NSMutableArray array];

    TextEntryCell *email = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setEmailCell:email];
    [cells addObject:email];
    [email configureWithTitle:NSLocalizedString(@"login.email.field.title", nil) value:@""];
    [email.entryField setReturnKeyType:UIReturnKeyNext];
    [email.entryField setKeyboardType:UIKeyboardTypeEmailAddress];
    [email setEditable:NO];

    TextEntryCell *password = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setPasswordCell:password];
    [cells addObject:password];
    [password configureWithTitle:NSLocalizedString(@"login.password.field.title", nil) value:@""];
    [password.entryField setReturnKeyType:UIReturnKeyDone];
    [password.entryField setSecureTextEntry:YES];

    [self setPresentedSectionCells:@[cells]];

    [self.tableView setTableFooterView:self.footerView];
    [self.footerButton setTitle:NSLocalizedString(@"button.title.done", nil) forState:UIControlStateNormal];
    [self.footerMessageLabel setText:NSLocalizedString(@"claim.account.footer.message.text", nil)];
    [self.footerMessageLabel setTextColor:[UIColor mainTextColor]];
    CGRect messageFrame = self.footerMessageLabel.frame;
    CGFloat fitHeight = [self.footerMessageLabel sizeThatFits:CGSizeMake(CGRectGetWidth(messageFrame), NSUIntegerMax)].height;
    messageFrame.size.height = fitHeight;
    [self.footerMessageLabel setFrame:messageFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setTitle:NSLocalizedString(@"claim.account.controller.title", nil)];
    [self.emailCell.entryField setText:[Credentials userEmail]];

    [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonWithTapHandler:^{
        [self.navigationController popViewControllerAnimated:YES];
    }]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.navigationController flattenStack];
}


- (IBAction)footerButtonPressed:(id)sender {
    [UIApplication dismissKeyboard];

    NSString *password = [self.passwordCell value];
    if (![password hasValue]) {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"claim.account.error.title", nil) message:NSLocalizedString(@"claim.account.password.not.entered", nil)];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
    [hud setMessage:NSLocalizedString(@"claim.account.setting.password.message", nil)];

    ClaimAccountOperation *operation = [ClaimAccountOperation operationWithPassword:password];
    [self setExecutedOperation:operation];

    [operation setResultHandler:^(NSError *error) {
        [hud hide];
        if (error) {
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"claim.account.error.title", nil) error:error];
            [alertView show];
            return;
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
    }];

    [operation execute];
}

@end
