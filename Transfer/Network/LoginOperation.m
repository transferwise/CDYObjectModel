//
//  LoginOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "LoginOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Credentials.h"
#import "TransferwiseClient.h"
#import "ObjectModel+RecipientTypes.h"
#import "FBAppEvents.h"
#import "GoogleAnalytics.h"
#import "AppsFlyerTracker.h"
#import "ObjectModel+Users.h"
#import "PaymentsOperation.h"
#import "User.h"
#import "Mixpanel+Customisation.h"

NSString *const kLoginPath = @"/token/create";

@interface LoginOperation ()

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@end

@implementation LoginOperation

- (id)initWithEmail:(NSString *)email password:(NSString *)password {
    self = [super init];
    if (self) {
        _email = email;
        _password = password;
    }
    return self;
}

+ (LoginOperation *)loginOperationWithEmail:(NSString *)email password:(NSString *)password {
    return [[LoginOperation alloc] initWithEmail:email password:password];
}

- (void)execute {
    MCLog(@"execute");

    NSString *path = [self addTokenToPath:kLoginPath];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"login"] = self.email;
    params[@"password"] = self.password;
    params[@"lifeTime"] = @"week";

    //Ensure no stale data is present before logging in.
    [self.objectModel clearUserRelatedData];
    
    __block __weak LoginOperation *weakSelf = self;
    [self setOperationSuccessHandler:^(NSDictionary *response) {
        [weakSelf.workModel performBlock:^{
            NSString *token = response[@"token"];
            [Credentials setUserToken:token];
            [Credentials setUserEmail:weakSelf.email];
            [[TransferwiseClient sharedClient] updateUserDetailsWithCompletionHandler:^(NSError *error) {
#if USE_APPSFLYER_EVENTS
                [AppsFlyerTracker sharedTracker].customerUserID = weakSelf.objectModel.currentUser.pReference;
                [[AppsFlyerTracker sharedTracker] trackEvent:@"sign-in" withValue:@""];
#endif
				if (weakSelf.waitForDetailsCompletion)
				{
                    //Attempt to retreive the user's transactions prior to showing the first logged in screen.
                    PaymentsOperation *operation = [PaymentsOperation operationWithOffset:0];
                    [weakSelf setExecutedOperation:operation];
                    [operation setObjectModel:weakSelf.objectModel];
                    [operation setCompletion:^(NSInteger totalCount, NSError *error)
                     {
                        weakSelf.responseHandler(nil);
                     }];
                    [operation execute];
				}
            }];

            [weakSelf.workModel removeOtherUsers];

#if USE_FACEBOOK_EVENTS
			[FBAppEvents logEvent:@"loggedIn"];
#endif
			[[GoogleAnalytics sharedInstance] markLoggedIn];
            
            [[Mixpanel sharedInstance] track:@"UserLogged"];
			
			[weakSelf.workModel saveContext:^{
				if (!weakSelf.waitForDetailsCompletion)
				{
					weakSelf.responseHandler(nil);
				}
			}];
        }];
    }];

    [self setOperationErrorHandler:^(NSError *error) {
        MCLog(@"Error:%@", error);
        weakSelf.responseHandler(error);
    }];

    [self postData:params toPath:path];
}


@end
