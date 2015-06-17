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
#import "ExpatDetectionLookupWrapper.h"
#import "User.h"
#import "ObjectModel+Users.h"
#import "PersonalProfile.h"
#import "ReferralsCoordinator.h"
#import "GoogleAnalytics.h"
#import "ObjectModel+Users.h"
#import "User.h"
#import "SectionButtonFlashHelper.h"

#define defaultRewardAmount 50
#define defaultRewardCurrency @"GBP"

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

-(void)viewDidLoad
{
    [super viewDidLoad];
    [SectionButtonFlashHelper inviteScreenHasBeenVisited];
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
	
    self.title = NSLocalizedString(@"invite.controller.title", nil);
    if(!IPAD)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    [self.inviteButtons[0] setTitle:NSLocalizedString(@"invite.button.title", nil) forState:UIControlStateNormal];
    [self.inviteButtons[1] setTitle:NSLocalizedString(@"invite.button.title", nil) forState:UIControlStateNormal];

    [self setProgress:self.numberOfFriends
             animated:NO];
    [self loadInviteStatus];
    
	[[GoogleAnalytics sharedInstance] sendScreen:GAInvite];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.numberOfFriends <= 0)
    {
        [self loadProfileImagesWithUser:[self.objectModel currentUser] requestAccess:NO];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.topItem.titleView = nil;
}


- (void)loadProfileImagesWithUser:(User *)user
					requestAccess:(BOOL)requestAccess
{
    AddressBookManager *manager = [[AddressBookManager alloc] init];
    
    [manager getPhoneLookupWithHandler:^(NSArray *phoneLookup) {
        NSMutableArray *workArray = [phoneLookup mutableCopy];
        NSMutableOrderedSet *options = [NSMutableOrderedSet orderedSet];
        NSString* ownNumber = user.personalProfile.phoneNumber;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            NSUInteger totalCount = 0;
            
            if (ownNumber)
            {
                //get profiles having pics, at least 2 numbers and of those 1 has the same country code
                for (ExpatDetectionLookupWrapper *wrapper in workArray)
                {
                    if (([wrapper hasPhonesWithDifferentCountryCodes]
                        && [wrapper hasPhoneWithMatchingCountryCode:ownNumber]))
                    {
                        totalCount++;
                        [options addObject:wrapper];
                    }
                }
                [workArray removeObjectsInArray:[options array]];
            }
            
            BOOL didSetImages = NO;
            if(options.count > [self.profilePictures count])
            {
                NSMutableOrderedSet *selectedOptions = [NSMutableOrderedSet orderedSetWithOrderedSet:options];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setProfileImagesFromSet:selectedOptions
							   addressBookManager:manager];
                });
                
                didSetImages = YES;
            }
            
            //if we didn't get the necessary amount, try to get more ignoring the "same country code" rule
			//also try to find profiles with phones/emails in different known countries
			//or profiles with different known email countries
            if (options.count < self.profilePictures.count)
            {
                for (ExpatDetectionLookupWrapper *wrapper in workArray)
                {
                    if ([wrapper hasPhonesWithDifferentCountryCodes]
						|| [wrapper hasPhoneAndEmailFromDifferentCountries]
						|| [wrapper hasEmailFromDifferentCountries])
                    {
                        totalCount++;
                        if(!didSetImages)
                        {
                            [options addObject:wrapper];
                        }
                    }
                }
            }
            
            if(!didSetImages)
            {
                NSMutableOrderedSet *selectedOptions = [NSMutableOrderedSet orderedSetWithOrderedSet:options];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setProfileImagesFromSet:selectedOptions
							   addressBookManager:manager];
                });
            }
            
            if(totalCount > 0)
            {
                [[GoogleAnalytics sharedInstance] sendEvent:GAExpatsfoundinab
												   category:GACategoryRecipient
													  label:[NSString stringWithFormat:@"%ld",(unsigned long)totalCount]];
            }
            
        });
    }
                         requestAccess:requestAccess];
}

-(void)setProfileImagesFromSet:(NSMutableOrderedSet*)options addressBookManager:(AddressBookManager*)manager
{
    //get images for chosen wrappers
    NSInteger limit = (options.count < self.profilePictures.count) ? options.count : self.profilePictures.count;
    for (NSInteger i = 0; i < limit; i++)
    {
        NSUInteger index = arc4random_uniform((u_int32_t)options.count);
        ExpatDetectionLookupWrapper* wrapper = options[index];
        [options removeObject:wrapper];
        [manager getImageForRecordId:wrapper.recordId requestAccess:NO completion:^(UIImage *image)
        {
            UIImageView *viewToChange = ((UIImageView *)self.profilePictures[i]);
            [UIView transitionWithView:viewToChange
                              duration:0.5f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                viewToChange.image = image;
                                [viewToChange layoutIfNeeded];
                            }
                            completion:nil];
        }];
    }

}

-(void)setProgress:(NSUInteger)progress
		  animated:(BOOL)animated
{
    self.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)progress];
    NSUInteger truncatedProgress = progress % 3;
    NSString* rewardString = [[ReferralsCoordinator sharedInstanceWithObjectModel:self.objectModel] rewardAmountString];
     self.headerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"invite.header", nil),rewardString];
    if(truncatedProgress > 0)
    {
        self.indicatorContainer.hidden = YES;
        if(progress == 1)
        {
            self.indicatorContextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"invite.progress.format1",nil),progress, 3 - truncatedProgress, rewardString] ;
        }
        else
        {
            self.indicatorContextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"invite.progress.format2",nil),progress, 3 - truncatedProgress];
        }
    }
    else
    {
        self.indicatorContextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"invite.complete.format",nil),progress,rewardString];
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
        NSString *earned = [NSString stringWithFormat:numberOfRewards>1?NSLocalizedString(@"invite.controller.title.rewards.format", nil):NSLocalizedString(@"invite.controller.title.reward.format", nil),numberOfRewards,boom];
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
	ReferralsCoordinator* coordinator = [ReferralsCoordinator sharedInstanceWithObjectModel:self.objectModel];
	coordinator.objectModel = self.objectModel;
	[coordinator presentOnController:self];
    if (self.numberOfFriends <= 0)
    {
        [self loadProfileImagesWithUser:[self.objectModel currentUser] requestAccess:YES];
    }
}

- (void)loadInviteStatus
{
	__weak InvitationsViewController *weakSelf = self;
	
    User *user = [self.objectModel currentUser];
    NSInteger amount = user.invitationRewardValue;
    [[ReferralsCoordinator sharedInstanceWithObjectModel:self.objectModel] requestRewardStatus:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error)
            {
                BOOL needsToRefresh = NO;
                User *user = [self.objectModel currentUser];
                if(amount != user.invitationRewardValue)
                {
                    needsToRefresh = YES;
                }
                if(user.successfulInviteCount)
                {
                    NSInteger successCount = user.successfulInviteCountValue;
                    if (successCount > self.numberOfFriends)
                    {
                        self.numberOfFriends = successCount;
                        needsToRefresh = YES;
                    }
                }
                
                if(needsToRefresh)
                {
                    [weakSelf setProgress:self.numberOfFriends
                                 animated:self.numberOfFriends == 0];
                }

            }
        });
    }];

}
@end
