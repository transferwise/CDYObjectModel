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
#import "Constants.h"
#import "ReferralLinkOperation.h"
#import "TRWAlertView.h"
#import "TRWProgressHUD.h"
#import "ReferralListOperation.h"
#import "AddressBookManager.h"
#import "PhoneLookupWrapper.h"
#import "User.h"
#import "ObjectModel+Users.h"
#import "PersonalProfile.h"

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
@property (strong, nonatomic) TransferwiseOperation *currentOperation;

//iPad
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation InvitationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
	User *user = [self.objectModel currentUser];
	
	NSString* ownNumber = user.personalProfile.phoneNumber;
	
	if (ownNumber)
	{
		AddressBookManager *manager = [[AddressBookManager alloc] init];
		
		[manager getPhoneLookupWithHandler:^(NSArray *phoneLookup) {
			NSMutableArray* matchingLookups = [[NSMutableArray alloc] initWithCapacity:self.profilePictures.count];
			
			//get profiles having pics, at least 2 numbers and of those 1 has the same country code
			for (PhoneLookupWrapper *wrapper in phoneLookup)
			{
				if(matchingLookups.count >= self.profilePictures.count)
				{
					break;
				}
				
				if ([wrapper hasMatchingPhones:ownNumber])
				{
					[matchingLookups addObject:wrapper];
				}
			}
			
			//get images for chosen wrappers
			int limit = (matchingLookups.count < self.profilePictures.count) ? matchingLookups.count : self.profilePictures.count;
			for (int i = 0; i < limit; i++)
			{
				[manager getImageForRecordId:((PhoneLookupWrapper *)matchingLookups[i]).recordId
								  completion:^(UIImage *image) {
									  UIImageView *viewToChange = ((UIImageView *)self.profilePictures[i]);
									  [UIView transitionWithView:viewToChange
														duration:0.5f
														 options:UIViewAnimationOptionTransitionCrossDissolve
													  animations:^{
														  viewToChange.image = image;
													  }
													  completion:nil];
								  }];
			}
		}];
	}
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"invite.controller.title", nil);
    if(!IPAD)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    self.headerLabel.text = NSLocalizedString(@"invite.header", nil);
    [self.inviteButtons[0] setTitle:NSLocalizedString(@"invite.button.title", nil) forState:UIControlStateNormal];
    [self.inviteButtons[1] setTitle:NSLocalizedString(@"invite.button.title", nil) forState:UIControlStateNormal];
    
	//init with 0 and load actual data
    [self setProgress:0];
	
	[self loadInviteStatus];
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
    self.numberOfFriends = progress;
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
        NSString *titleText = NSLocalizedString(@"invite.controller.title", nil);
        if(IPAD)
        {
            self.titleLabel.attributedText = nil;
            self.titleLabel.text = titleText;
        }
        else
        {
            self.navigationController.navigationBar.topItem.title = titleText;
            self.navigationController.navigationBar.topItem.titleView = nil;
        }
    }
    else if(numberOfRewards <1)
    {
        NSString *titleText = NSLocalizedString(@"invite.controller.title.short", nil);
        
        if(IPAD)
        {
            self.titleLabel.attributedText = nil;
            self.titleLabel.text = titleText;
        }
        else
        {
            self.navigationController.navigationBar.topItem.title = titleText;
            self.navigationController.navigationBar.topItem.titleView = nil;
        }
    }
    else
    {
        NSString * boom = NSLocalizedString(@"invite.controller.title.boom", nil);
        NSString *earned = [NSString stringWithFormat:NSLocalizedString(@"invite.controller.title.reward.format", nil),50*numberOfRewards,boom];
        NSMutableAttributedString *finalText= [[NSMutableAttributedString alloc] initWithString:earned];
        [finalText addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromStyle:@"twelectricblue"] range:[earned rangeOfString:boom]];
        
        if(IPAD)
        {
            self.titleLabel.text = nil;
            self.titleLabel.attributedText = finalText;
        }
        else
        {
            UILabel *titleLabel = [[UILabel alloc]init];
            titleLabel.numberOfLines = 1;
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.fontStyle = @"heavy.@{17,19}.DarkFont";
            
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
    
}

- (IBAction)inviteButtonTapped:(id)sender
{
	TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
	[hud setMessage:NSLocalizedString(@"invite.link.querying", nil)];
	ReferralLinkOperation *referralLinkOperation = [ReferralLinkOperation operation];
	self.currentOperation = referralLinkOperation;
	__weak InvitationsViewController *weakSelf = self;
	
    [referralLinkOperation setResultHandler:^(NSError *error, NSString *referralLink)
	 {
		 dispatch_async(dispatch_get_main_queue(), ^{
			 [hud hide];
			 
			 if (!error && referralLink)
			 {
				 InviteViewController *controller = [[InviteViewController alloc] init];
				 controller.inviteUrl = referralLink;
				 controller.objectModel = weakSelf.objectModel;
				 [controller presentOnViewController:weakSelf.view.window.rootViewController];
				 return;
			 }
			 
			 TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"invite.link.error.title", nil)
																message:NSLocalizedString(@"invite.link.error.message", nil)];
			 [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
			 [alertView show];
		 });
	 }];
	
    [referralLinkOperation execute];
}

- (void)loadInviteStatus
{
	ReferralListOperation *referralLinkOperation = [ReferralListOperation operation];
	self.currentOperation = referralLinkOperation;
	__weak InvitationsViewController *weakSelf = self;
	
    [referralLinkOperation setResultHandler:^(NSError *error, NSInteger successCount)
	 {
		 dispatch_async(dispatch_get_main_queue(), ^{
			 if (!error && successCount > -1)
			 {
				 [weakSelf setProgress:successCount];
				 return;
			 }
			 
			 TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"invite.status.error.title", nil)
																message:NSLocalizedString(@"invite.status.error.message", nil)];
			 [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
			 [alertView show];
		 });
	 }];
	
    [referralLinkOperation execute];
}

@end
