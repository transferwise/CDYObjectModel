//
//  BusinessProfileIdentificationViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 9/20/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "BusinessProfileIdentificationViewController.h"
#import "TransferBackButtonItem.h"
#import "TRWProgressHUD.h"
#import "TRWAlertView.h"

@interface BusinessProfileIdentificationViewController ()
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

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

    [self.actionButton setTitle:NSLocalizedString(@"",nil) forState:UIControlStateNormal];
    self.textLabel.text = NSLocalizedString(@"",nil);
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setTitle:NSLocalizedString(@"business.profile.identification.controller.title", nil)];

    [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController]];
}



- (IBAction)skipPressed {
    [self executeCompletion:YES];
}

- (void)executeCompletion:(BOOL)skipped {
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"business.profile.identification.making.payment.message", nil)];

    self.completionHandler(skipped, @"", ^(void){
        [hud hide];
    }, ^(NSError *error) {
        [hud hide];
        if (error) {
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"identification.payment.error.title", nil) error:error];
            [alertView show];
        }
    });
}

@end
