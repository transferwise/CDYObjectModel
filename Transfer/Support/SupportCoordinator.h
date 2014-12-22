//
//  SupportCoordinator.h
//  Transfer
//
//  Created by Jaanus Siim on 9/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ObjectModel;

@interface SupportCoordinator : NSObject

@property (nonatomic, strong) ObjectModel *objectModel;

- (id)init __attribute__((unavailable("init unavailable, use sharedInstance")));
+ (SupportCoordinator *)sharedInstance;

- (void)presentOnController:(UIViewController *)controller;
- (void)presentOnController:(UIViewController *)controller emailSubject:(NSString *)emailSubject;

@end
