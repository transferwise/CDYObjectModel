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
#import "TRWAlertView.h"
#import "ReferralListOperation.h"
#import "AddressBookManager.h"
#import "PhoneLookupWrapper.h"
#import "User.h"
#import "ObjectModel+Users.h"
#import "PersonalProfile.h"
#import "ReferralsCoordinator.h"
#import "GoogleAnalytics.h"
#import "ObjectModel+Users.h"
#import "User.h"

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
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	User *user = [self.objectModel currentUser];
	self.numberOfFriends = user.successfulInviteCountValue;
	
	if (self.numberOfFriends > 0)
	{
		self.profilePictureContainer.hidden = YES;
		self.indicatorContainer.hidden = NO;
	}
	else
	{
		[self loadProfileImagesWithUser:user];
	}
	
    self.title = NSLocalizedString(@"invite.controller.title", nil);
    if(!IPAD)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    self.headerLabel.text = NSLocalizedString(@"invite.header", nil);
    [self.inviteButtons[0] setTitle:NSLocalizedString(@"invite.button.title", nil) forState:UIControlStateNormal];
    [self.inviteButtons[1] setTitle:NSLocalizedString(@"invite.button.title", nil) forState:UIControlStateNormal];
	
	[self setProgress:self.numberOfFriends
			 animated:NO];
	[self loadInviteStatus];
    
	[[GoogleAnalytics sharedInstance] sendScreen:[NSString stringWithFormat:@"Invite"]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.topItem.titleView = nil;
}

- (void)loadProfileImagesWithUser:(User *)user
{
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
				
				if ([wrapper hasPhonesWithDifferentCountryCodes]
					&& [wrapper hasPhoneWithMatchingCountryCode:ownNumber])
				{
					[matchingLookups addObject:wrapper];
				}
			}
			
			//if we didn't get the necessary amount, try to get more ignoring the "same country code" rule
			if (matchingLookups.count < self.profilePictures.count)
			{
				for (PhoneLookupWrapper *wrapper in phoneLookup)
				{
					if ([wrapper hasPhonesWithDifferentCountryCodes]
						&& [matchingLookups indexOfObject:wrapper] == NSNotFound)
					{
						[matchingLookups addObject:wrapper];
						
						if (matchingLookups.count >= self.profilePictures.count)
						{
							break;
						}
					}
				}
			}
			
			//get images for chosen wrappers
			NSInteger limit = (matchingLookups.count < self.profilePictures.count) ? matchingLookups.count : self.profilePictures.count;
			for (NSInteger i = 0; i < limit; i++)
			{
				[manager getImageForRecordId:((PhoneLookupWrapper *)matchingLookups[i]).recordId
							   requestAccess:NO
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
		}
							 requestAccess:NO];
	}
}

-(void)setProgress:(NSUInteger)progress
		  animated:(BOOL)animated
{
    self.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)progress];
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
	
	if (progress > 0 && animated)
	{
		//indicator view is always hidden
		self.indicatorContainer.opaque = NO;
		self.indicatorContainer.alpha = 0.f;
		self.indicatorContainer.hidden = NO;
		self.profilePictureContainer.opaque = NO;
		self.profilePictureContainer.alpha = 1.f;
		
		[UIView animateWithDuration:0.5f
						 animations:^{
							 self.profilePictureContainer.alpha = 0.f;
							 self.indicatorContainer.alpha = 1.f;
						 }
						 completion:^(BOOL finished){
							 self.profilePictureContainer.hidden = YES;
							 self.profilePictureContainer.opaque = YES;
							 self.profilePictureContainer.alpha = 1.f;
							 self.indicatorContainer.opaque = YES;
						 }];
	}
	
	self.profilePictureContainer.hidden = progress > 0;
	self.indicatorContainer.hidden = ! self.profilePictureContainer.hidden;
	
    if(progress >0)
    {
        [self.progressIndicator setProgress:progress animated:YES];
    }

    NSUInteger numberOfRewards = progress/3;
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
	ReferralsCoordinator* coordinator = [ReferralsCoordinator sharedInstance];
	coordinator.objectModel = self.objectModel;
	[coordinator presentOnController:self];
}

- (void)loadInviteStatus
{
	ReferralListOperation *referralLinkOperation = [ReferralListOperation operation];
	self.currentOperation = referralLinkOperation;
	[referralLinkOperation setObjectModel:self.objectModel];
	__weak InvitationsViewController *weakSelf = self;
	
    [referralLinkOperation setResultHandler:^(NSError *error, NSInteger successCount) {
		 dispatch_async(dispatch_get_main_queue(), ^{
			 if (!error && successCount > -1)
			 {
				 if (successCount > self.numberOfFriends)
				 {
					 self.numberOfFriends = successCount;
					 [weakSelf setProgress:successCount
								  animated:self.numberOfFriends == 0];
				 }
				 
				 return;
			 }
		 });
	 }];
	
    [referralLinkOperation execute];
}

@end
