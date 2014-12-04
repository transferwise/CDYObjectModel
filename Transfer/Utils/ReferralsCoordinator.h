//
//  ReferralsCoordinator.h
//  Transfer
//
//  Created by Juhan Hion on 27.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ObjectModel;

@interface ReferralsCoordinator : NSObject

@property (nonatomic, strong) ObjectModel *objectModel;

+ (ReferralsCoordinator *)sharedInstanceWithObjectModel:(ObjectModel*)objectModel;

- (void)presentOnController:(UIViewController *)controller;
- (void)requestRewardStatus:(void(^)(NSError*))completionBlock;
- (NSString*)rewardAmountString;
@end
