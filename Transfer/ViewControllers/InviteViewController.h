//
//  InviteViewController.h
//  Transfer
//
//  Created by Mats Trovik on 14/08/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransparentModalViewController.h"
@class ObjectModel;

@interface InviteViewController : TransparentModalViewController

@property (nonatomic, strong) ObjectModel *objectModel;

- (id)init __attribute__((unavailable("init unavailable, use initWithRewardAmount:")));
- (instancetype)initWithReferralLinks:(NSArray *)referralLinks
						 rewardAmount:(NSString *)rewardAmountString;

@end
