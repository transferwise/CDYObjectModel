//
//  OAuthViewController.h
//  Transfer
//
//  Created by Juhan Hion on 25.02.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

@class ObjectModel;

#import <UIKit/UIKit.h>

@interface OAuthViewController : UIViewController

@property (nonatomic, assign) BOOL registerUser;

- (id)init __attribute__((unavailable("init unavailable, use initWithProvider:url:objectModel")));
- (instancetype)initWithProvider:(NSString *)provider
							 url:(NSURL *)requestUrl
					 objectModel:(ObjectModel *)objectModel;

@end
