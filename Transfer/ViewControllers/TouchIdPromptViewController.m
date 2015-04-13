//
//  TouchIdPromptViewController.m
//  Transfer
//
//  Created by Mats Trovik on 08/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TouchIdPromptViewController.h"
#import "TouchIDHelper.h"
#import "Constants.h"
#import "GoogleAnalytics.h"
#import "AuthenticationHelper.h"

@interface TouchIdPromptViewController ()
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;

@property (nonatomic,strong) NSString* username;
@property (nonatomic,strong) NSString* password;

@end

@implementation TouchIdPromptViewController

-(void)viewDidLoad
{
    self.descriptionLabel.text = NSLocalizedString(@"touchid.prompt.info", nil);
    self.titleLabel.text = NSLocalizedString(@"touchid.prompt.title", nil);
    [super viewDidLoad];
}

-(void)presentOnViewController:(UIViewController *)hostViewcontroller withUsername:(NSString *)username password:(NSString *)password
{
    self.username = username;
    self.password = password;
    [super presentOnViewController:hostViewcontroller];
    
}

- (IBAction)noTapped:(id)sender {
    [[GoogleAnalytics sharedInstance] sendAppEvent:GATouchidprompted withLabel:@"Declined"];
    [TouchIDHelper blockStorageForUsername:self.username];
    [self finish];
}
- (IBAction)yesTapped:(id)sender {
    [[GoogleAnalytics sharedInstance] sendAppEvent:GATouchidprompted withLabel:@"Accepted"];
    [TouchIDHelper storeCredentialsWithUsername:self.username password:self.password result:^(BOOL success) {
        if(success)
        {
            [[GoogleAnalytics sharedInstance] sendAppEvent:GATouchidsetup];
            [self finish];
        }
    }];
}

-(IBAction)finish
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self.touchIdDelegate touchIdPromptIsFinished:self];
}

@end
