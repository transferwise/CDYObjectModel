//
//  BusinessProfileIdentificationViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 9/20/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "BusinessProfileIdentificationViewController.h"
#import "TextContainerView.h"
#import "UIColor+Theme.h"
#import "ObjectModel.h"
#import "UITableView+FooterPositioning.h"
#import "TransferBackButtonItem.h"
#import "BlueButton.h"
#import "ConfirmPaymentCell.h"
#import "GrayButton.h"
#import "TRWAlertView.h"
#import "ObjectModel+Users.h"
#import "User.h"
#import "BusinessProfile.h"
#import "TRWProgressHUD.h"

@interface BusinessProfileIdentificationViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) IBOutlet TextContainerView *headerView;
@property (nonatomic, strong) IBOutlet TextContainerView *footerView;
@property (nonatomic, strong) IBOutlet BlueButton *sentButton;
@property (nonatomic, strong) IBOutlet GrayButton *skipButton;

- (IBAction)sentPressed;
- (IBAction)skipPressed;

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (![MFMailComposeViewController canSendMail]) {
        TRWAlertView *alert = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"support.cant.send.email.title", nil)
                                                       message:NSLocalizedString(@"support.cant.send.email.message", nil)];
        [alert setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alert show];
        return;
    }

    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    [controller setMailComposeDelegate:self];
    [controller setToRecipients:@[TRWIdentificationEmail]];
    [controller setSubject:NSLocalizedString(@"identification.email.subject", nil)];
    NSString *messageBody = [NSString stringWithFormat:NSLocalizedString(@"identification.email.message.body.base", nil),
                                                       [[self.objectModel currentUser] email],
                                                       [[[self.objectModel currentUser] businessProfile] name],
                                                       [[UIDevice currentDevice] systemVersion],
                                                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
    ];

    [controller setMessageBody:messageBody isHTML:YES];

    [self presentViewController:controller animated:YES completion:^{
        if (IOS_7) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }
    }];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (error) {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"support.send.email.error.title", nil)
                                                           message:NSLocalizedString(@"support.send.email.error.message", nil)];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }

    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sentPressed {
    [self executeCompletion:NO];
}

- (IBAction)skipPressed {
    [self executeCompletion:YES];
}

- (void)executeCompletion:(BOOL)skipped {
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
    [hud setMessage:NSLocalizedString(@"business.profile.identification.making.payment.message", nil)];

    self.completionHandler(skipped, @"", ^(NSError *error) {
        [hud hide];
        if (error) {
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"identification.payment.error.title", nil) error:error];
            [alertView show];
        }
    });
}

@end
