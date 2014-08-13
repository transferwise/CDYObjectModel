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
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (nonatomic,assign) NSUInteger numberOfFriends;

@property (weak, nonatomic) IBOutlet InvitationProgressIndicatorView *progressIndicator;

//Constraints
@property (weak, nonatomic) IBOutlet UILabel *indicatorContextLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileImagesContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileImagesOntainerTopSpaceConstraint;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.headerLabel.text = NSLocalizedString(@"invite.header", nil);
    [self.inviteButton setTitle:NSLocalizedString(@"invite.button.title", nil) forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"invite.controller.title", nil);
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.numberLabel.text = [NSString stringWithFormat:@"%d",self.numberOfFriends];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)inviteButtonTapped:(id)sender {
    self.numberOfFriends ++;
    self.numberOfFriends = self.numberOfFriends%5;
    self.numberLabel.text = [NSString stringWithFormat:@"%d",self.numberOfFriends];
    if(self.numberOfFriends >0)
    {
        [self.progressIndicator setProgress:self.numberOfFriends animated:YES];
    }
}

@end
