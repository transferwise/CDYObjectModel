//
//  ProfileSource.m
//  Transfer
//
//  Created by Jaanus Siim on 6/12/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ProfileSource.h"
#import "PhoneBookProfile.h"
#import "TransferwiseClient.h"
#import "Credentials.h"
#import "Constants.h"

@implementation ProfileSource

- (NSArray *)presentedCells {
    ABSTRACT_METHOD;
    return @[];
}

- (NSString *)editViewTitle {
    ABSTRACT_METHOD;
    return nil;
}

- (void)pullDetailsWithHandler:(ProfileActionBlock)handler {
    MCAssert(self.objectModel);

    if (![Credentials userLoggedIn]) {
        handler(nil);
        return;
    }

    [[TransferwiseClient sharedClient] updateUserDetailsWithCompletionHandler:^(NSError *userError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (userError) {
                handler(userError);
                return;
            }

            [self loadDetailsToCells];
            handler(nil);
        });
    }];
}

- (void)loadDataFromProfile:(PhoneBookProfile *)profile {
    ABSTRACT_METHOD;
}

- (BOOL)inputValid {
    ABSTRACT_METHOD;
    return NO;
}

- (id)enteredProfile {
    ABSTRACT_METHOD;
    return nil;
}

- (void)validateProfile:(id)profile withValidation:(id)validation completion:(ProfileActionBlock)completion {
    ABSTRACT_METHOD;
}

- (NSString *)titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)loadDetailsToCells {
    ABSTRACT_METHOD;
}

@end
