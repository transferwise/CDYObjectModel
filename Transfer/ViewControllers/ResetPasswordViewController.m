//
//  ResetPasswordViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 09/05/14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "TransferBackButtonItem.h"
#import "UIColor+Theme.h"
#import "TextEntryCell.h"
#import "UIView+Loading.h"
#import "ObjectModel.h"
#import "UITableView+FooterPositioning.h"
#import "NSString+Validation.h"
#import "TRWProgressHUD.h"
#import "ResetPasswordOperation.h"
#import "TRWAlertView.h"
#import "NSError+TRWErrors.h"

@interface ResetPasswordViewController ()

@property (nonatomic, strong) TextEntryCell *emailCell;
@property (nonatomic, strong) IBOutlet UIView *footerView;
@property (nonatomic, strong) IBOutlet UIButton *continueButton;

@end

@implementation ResetPasswordViewController

- (id)init {
    self = [super initWithNibName:@"ResetPasswordViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];

    [self.navigationItem setTitle:NSLocalizedString(@"reset.password.controller.title", nil)];
    [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController]];

    [self.tableView registerNib:[TextEntryCell viewNib] forCellReuseIdentifier:TWTextEntryCellIdentifier];

    TextEntryCell *emailCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setEmailCell:emailCell];
    [emailCell.entryField setKeyboardType:UIKeyboardTypeEmailAddress];
    [emailCell configureWithTitle:NSLocalizedString(@"reset.password.controller.email.cell.label", nil) value:@""];

    [self setPresentedSectionCells:@[@[emailCell]]];

    //TODO jaanus: copy/paste
    CGRect headerFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 40, 100);
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerFrame];
    [headerLabel setNumberOfLines:0];
    [headerLabel setFont:[UIFont systemFontOfSize:14]];
    [headerLabel setTextColor:[UIColor mainTextColor]];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setText:NSLocalizedString(@"reset.password.header.description", nil)];
    CGFloat fitHeight = [headerLabel sizeThatFits:CGSizeMake(CGRectGetWidth(headerFrame), CGFLOAT_MAX)].height;
    headerFrame.size.height = fitHeight;
    headerFrame.origin.x = 20;
    headerFrame.origin.y = 100;
    [headerLabel setFrame:headerFrame];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(headerFrame) + 100 + 20)];
    [header setBackgroundColor:[UIColor clearColor]];
    [header addSubview:headerLabel];
    [self.tableView setTableHeaderView:header];

    [self.tableView setTableFooterView:self.footerView];

    [self.continueButton setTitle:NSLocalizedString(@"reset.controller.footer.button.title", nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.tableView adjustFooterViewSizeForMinimumHeight:44];
}

- (IBAction)resetPasswordPressed {
    NSString *email = [self.emailCell value];
    if (![email hasValue]) {
        [self showError:NSLocalizedString(@"reset.password.email.not.entered", nil)];
        return;
    } else if (![email isValidEmail]) {
        [self showError:NSLocalizedString(@"reset.password.invaild.email.error", nil)];
        return;
    }

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    ResetPasswordOperation *operation = [[ResetPasswordOperation alloc] init];
    [operation setEmail:email];
    [operation setObjectModel:self.objectModel];
    [operation setResultHandler:^(NSError *error) {
        [hud hide];
        if (!error) {
            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"reset.password.success.alert.title", nil) message:NSLocalizedString(@"reset.password.success.alert.message", nil)];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"reset.password.alert.dismiss.button", nil) action:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertView show];
            return;
        }

        if (error.twCodeNotFound) {
            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"reset.password.failed.alert.title", nil) message:NSLocalizedString(@"reset.password.not.found.alert.message", nil)];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"reset.password.alert.dismiss.button", nil)];
            [alertView show];
        } else {
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"reset.password.failed.alert.title", nil) error:error];
            [alertView show];
        }
    }];
    [operation execute];
}

- (void)showError:(NSString *)message {
    TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"reset.password.error.title", nil) message:message];
    [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
    [alertView show];
}

@end
