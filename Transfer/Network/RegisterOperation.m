//
//  RegisterOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RegisterOperation.h"
#import "TransferwiseOperation+Private.h"
#import "TransferwiseClient.h"
#import "Credentials.h"

NSString *const kRegisterPath = @"/api/v1/token/register";

@interface RegisterOperation ()

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;

@end

@implementation RegisterOperation

- (id)initWithEmail:(NSString *)email password:(NSString *)password {
    self = [super init];
    if (self) {
        _email = email;
        _password = password;
    }
    return self;
}

- (void)execute {
    __block __weak RegisterOperation *weakSelf = self;

    self.operationErrorHandler = ^(NSError *error) {
        weakSelf.completionHandler(error);
    };

    self.operationSuccessHandler = ^(NSDictionary *response) {
        //TODO jaanus: copy/paste from Login operation
        NSString *token = response[@"token"];
        [Credentials setUserToken:token];
        [[TransferwiseClient sharedClient] updateUserDetailsWithCompletionHandler:nil];

        weakSelf.completionHandler(nil);
    };

    //TODO jaanus: remove pass2 after server change
    [self postData:@{@"email" : self.email, @"password" : self.password, @"password2" : self.password} toPath:kRegisterPath];
}

+ (RegisterOperation *)operationWithEmail:(NSString *)email password:(NSString *)password {
    return [[RegisterOperation alloc] initWithEmail:email password:password];
}

@end
