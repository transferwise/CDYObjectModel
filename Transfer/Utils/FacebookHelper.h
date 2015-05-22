//
//  FacebookHelper.h
//  Transfer
//
//  Created by Juhan Hion on 22.05.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

typedef void (^FacebookLoginSuccessBlock)(NSString *accessToken, NSString *email, BOOL isExisting);

@interface FacebookHelper : NSObject

- (void)performFacebookLoginWithSuccessBlock:(FacebookLoginSuccessBlock)successBlock
								 cancelBlock:(TRWActionBlock)cancelBlock
						navigationController:(UINavigationController *)navigationController;
- (void)logOut;

@end
