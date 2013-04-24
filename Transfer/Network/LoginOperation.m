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

NSString *const kLoginPath = @"/api/v1/token/create";

@interface LoginOperation ()

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;

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

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"login"] = self.email;
    params[@"password"] = self.password;

    __block __weak LoginOperation *weakSelf = self;
    [self setOperationSuccessHandler:^(NSDictionary *response) {
        NSString *token = response[@"token"];
        [Credentials setUserToken:token];
        [[TransferwiseClient sharedClient] updateUserDetailsWithCompletionHandler:nil];

        weakSelf.responseHandler(nil);
    }];
    [self setOperationErrorHandler:^(NSError *error) {
        MCLog(@"Error:%@", error);
        weakSelf.responseHandler(error);
    }];

    [self postData:params toPath:kLoginPath];
}


@end
