//
//  InvitationsViewController.m
//  Transfer
//
//  Created by Mats Trovik on 13/08/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "InvitationsViewController.h"
#import "InvitationProgressIndicatorView.h"
#import "MOMStyle.h"
#import "InviteViewController.h"

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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.topItem.titleView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setProgress:(NSUInteger)progress
{
    self.numberLabel.text = [NSString stringWithFormat:@"%d",progress];
    NSUInteger truncatedProgress = progress % 3;
    if(truncatedProgress > 0)
    {
        self.indicatorContainer.hidden = YES;
        self.indicatorContextLabel.text = [NSString stringWithFormat:NSLocalizedString(progress==1?@"invite.progress.format1":@"invite.progress.format2",nil),progress, 3 - truncatedProgress];
    }
    else
    {
        self.indicatorContextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"invite.complete.format",nil),progress];
    }
    if(progress >0)
    {
        [self.progressIndicator setProgress:progress animated:YES];
    }

    self.profilePictureContainer.hidden = progress > 0;
    self.indicatorContainer.hidden = ! self.profilePictureContainer.hidden;

    int numberOfRewards = progress/3;
    if(numberOfRewards == 0 && progress == 0)
    {
        self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"invite.controller.title", nil);
        self.navigationController.navigationBar.topItem.titleView = nil;
    }
    else if(numberOfRewards <1)
    {
        self.navigationController.navigationBar.topItem.title= NSLocalizedString(@"invite.controller.title.short", nil);
        self.navigationController.navigationBar.topItem.titleView = nil;
    }
    else
    {
        NSString * boom = NSLocalizedString(@"invite.controller.title.boom", nil);
        NSString *earned = [NSString stringWithFormat:NSLocalizedString(@"invite.controller.title.reward.format", nil),50*numberOfRewards,boom];
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.numberOfLines = 1;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.fontStyle = @"heavy.@{17,19}.DarkFont";
        NSMutableAttributedString *finalText= [[NSMutableAttributedString alloc] initWithString:earned];
        [finalText addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromStyle:@"twelectricblue"] range:[earned rangeOfString:boom]];
        titleLabel.attributedText = finalText;
        [titleLabel sizeToFit];
        CGRect newFrame = titleLabel.frame;
        newFrame.origin.y = 2;
        titleLabel.frame = newFrame;
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, newFrame.size.width, newFrame.size.height+2)];
        [container addSubview:titleLabel];
        
        self.navigationController.navigationBar.topItem.titleView = container;
    }
    
}


- (IBAction)inviteButtonTapped:(id)sender {
    InviteViewController *controller = [[InviteViewController alloc] init];
    [controller presentOnViewController:self.view.window.rootViewController];
    
    self.numberOfFriends ++;
    self.numberOfFriends = self.numberOfFriends%10;
    [self setProgress:self.numberOfFriends];
}

@end
