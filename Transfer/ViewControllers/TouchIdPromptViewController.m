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

- (IBAction)closeTapped:(id)sender {
    [TouchIDHelper blockStorageForUsername:self.username];
    [[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
}
- (IBAction)yesTapped:(id)sender {
    [TouchIDHelper storeCredentialsWithUsername:self.username password:self.password result:^(BOOL success) {
        if(success)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
        }
    }];
}

@end
