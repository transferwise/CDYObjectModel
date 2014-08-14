//
//  InviteViewController.m
//  Transfer
//
//  Created by Mats Trovik on 14/08/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "InviteViewController.h"

@interface InviteViewController ()
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *smsButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contextLabel;

@end

@implementation InviteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.facebookButton setTitle:NSLocalizedString(@"invite.fb.button.title", @"") forState:UIControlStateNormal];
    [self.emailButton setTitle:NSLocalizedString(@"invite.email.button.title", @"") forState:UIControlStateNormal];
    [self.smsButton setTitle:NSLocalizedString(@"invite.sms.button.title", @"") forState:UIControlStateNormal];
    self.titleLabel.text = NSLocalizedString(@"invite.modal.title", nil);
    self.contextLabel.text = NSLocalizedString(@"invite.context", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookTapped:(id)sender {
}

- (IBAction)emailTapped:(id)sender {
}

- (IBAction)smsTapped:(id)sender {
}

@end
