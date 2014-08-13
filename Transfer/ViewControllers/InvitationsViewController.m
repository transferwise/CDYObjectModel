//
//  InvitationsViewController.m
//  Transfer
//
//  Created by Mats Trovik on 13/08/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "InvitationsViewController.h"
#import "InvitationProgressIndicatorView.h"

@interface InvitationsViewController ()
@property (weak, nonatomic) IBOutlet UIView *profilePictureContainer;
@property (weak, nonatomic) IBOutlet UIView *indicatorContainer;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *profilePictures;
@property (strong, nonatomic) IBOutlet IBOutletCollection(UIButton) NSArray *inviteButtons;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (nonatomic,assign) NSUInteger numberOfFriends;

@property (weak, nonatomic) IBOutlet InvitationProgressIndicatorView *progressIndicator;

@property (weak, nonatomic) IBOutlet UILabel *indicatorContextLabel;


@end

@implementation InvitationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"invite.controller.title", nil);
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.headerLabel.text = NSLocalizedString(@"invite.header", nil);
    [self.inviteButtons[0] setTitle:NSLocalizedString(@"invite.button.title", nil) forState:UIControlStateNormal];
    [self.inviteButtons[1] setTitle:NSLocalizedString(@"invite.button.title", nil) forState:UIControlStateNormal];
    
    self.numberLabel.text = [NSString stringWithFormat:@"%d",self.numberOfFriends];
    [self setProgress:self.numberOfFriends];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setProgress:(NSUInteger)progress
{
    self.numberLabel.text = [NSString stringWithFormat:@"%d",self.numberOfFriends];
    NSUInteger truncatedProgress = progress % 3;
    if(truncatedProgress > 0)
    {
        self.indicatorContainer.hidden = YES;
        self.indicatorContextLabel.text = [NSString stringWithFormat:NSLocalizedString(truncatedProgress==2?@"invite.progress.format2":@"invite.progress.format1",nil),progress, 3 - truncatedProgress];
    }
    else
    {
        self.indicatorContextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"invite.complete.format",nil),progress];
    }
    if(self.numberOfFriends >0)
    {
        [self.progressIndicator setProgress:self.numberOfFriends animated:YES];
    }

    self.profilePictureContainer.hidden = progress > 0;
    self.indicatorContainer.hidden = ! self.profilePictureContainer.hidden;

}


- (IBAction)inviteButtonTapped:(id)sender {
    self.numberOfFriends ++;
    self.numberOfFriends = self.numberOfFriends%10;
    [self setProgress:self.numberOfFriends];
}

@end
