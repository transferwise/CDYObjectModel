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
@property (nonatomic,strong) NSNumberFormatter *currencyFormatter;


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
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyFormatter setCurrencyCode:defaultRewardCurrency];
    [currencyFormatter setMaximumFractionDigits:0];
    [currencyFormatter setMinimumFractionDigits:0];
    self.currencyFormatter = currencyFormatter;
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	User *user = [self.objectModel currentUser];
	self.numberOfFriends = user.successfulInviteCountValue;
    [self.currencyFormatter setCurrencyCode:([user.invitationRewardCurrency length] == 3)?user.invitationRewardCurrency:defaultRewardCurrency];
	
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
    
    self.headerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"invite.header", nil),[self rewardString]];
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
    AddressBookManager *manager = [[AddressBookManager alloc] init];
    
    [manager getPhoneLookupWithHandler:^(NSArray *phoneLookup) {
        
        NSMutableArray* matchingLookups = [[NSMutableArray alloc] initWithCapacity:self.profilePictures.count];
        
        NSString* ownNumber = user.personalProfile.phoneNumber;
        if (ownNumber)
        {
            
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
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSUInteger totalCount = limit;
            if (limit < 1)
            {
                return;
            }
            if(limit >= [self.profilePictures count])
            {
                totalCount = 0;
                for (PhoneLookupWrapper *wrapper in phoneLookup)
                {
                    if ([wrapper hasPhonesWithDifferentCountryCodes])
                    {
                        totalCount++;
                    }
                }
            }
            [[GoogleAnalytics sharedInstance] sendEvent:@"expatsfoundinAB" category:@"recipient" label:[NSString stringWithFormat:@"%ld",(unsigned long)totalCount]];
        });
        
    }
                         requestAccess:NO];
}

-(void)setProgress:(NSUInteger)progress
		  animated:(BOOL)animated
{
    self.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)progress];
    NSUInteger truncatedProgress = progress % 3;
    if(truncatedProgress > 0)
    {
        self.indicatorContainer.hidden = YES;
        if(progress == 1)
        {
            self.indicatorContextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"invite.progress.format1",nil),progress, 3 - truncatedProgress, [self rewardString]] ;
        }
        else
        {
            self.indicatorContextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"invite.progress.format2",nil),progress, 3 - truncatedProgress];
        }
    }
    else
    {
        self.indicatorContextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"invite.complete.format",nil),progress,[self rewardString]];
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
    self.numberOfFriends++;
    [self setProgress: self.numberOfFriends
                 animated:YES];
    
//	ReferralsCoordinator* coordinator = [ReferralsCoordinator sharedInstance];
//	coordinator.objectModel = self.objectModel;
//	[coordinator presentOnController:self];
}

- (void)loadInviteStatus
{
	ReferralListOperation *referralLinkOperation = [ReferralListOperation operation];
	self.currentOperation = referralLinkOperation;
	[referralLinkOperation setObjectModel:self.objectModel];
	__weak InvitationsViewController *weakSelf = self;
	
    [referralLinkOperation setResultHandler:^(NSError *error) {
		 dispatch_async(dispatch_get_main_queue(), ^{
			 if (!error)
			 {
                 User *user = [self.objectModel currentUser];
                 if ([user.invitationRewardCurrency length] == 3)
                 {
                     self.currencyFormatter.currencyCode = user.invitationRewardCurrency;
                 }
                 if(user.successfulInviteCount)
                 {
                     NSInteger successCount = user.successfulInviteCountValue;
                     if (successCount > self.numberOfFriends)
                     {
                         self.numberOfFriends = successCount;
                         [weakSelf setProgress:successCount
                                      animated:self.numberOfFriends == 0];
                     }
                 }
			 }
		 });
	 }];
	
    [referralLinkOperation execute];
}

-(NSString*)rewardString
{
    NSNumber *rewardNumber =@(defaultRewardAmount);
    
    if([[self.objectModel currentUser].invitationReward intValue] > 0)
    {
        rewardNumber = [self.objectModel currentUser].invitationReward;
    }
    
    return [self.currencyFormatter stringFromNumber:rewardNumber];
}
@end
