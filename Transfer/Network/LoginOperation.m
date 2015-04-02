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
#import "ObjectModel+Users.h"
#import "PaymentsOperation.h"
#import "User.h"

NSString *const kLoginPath = @"/token/create";

@interface LoginOperation ()

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic) BOOL keepPendingPayment;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@end

@implementation LoginOperation

- (id)initWithEmail:(NSString *)email password:(NSString *)password keepPendingPayment:(BOOL)keepPendingPayment
{
    self = [super init];
    if (self) {
        _email = email;
        _password = password;
        _keepPendingPayment = keepPendingPayment;
    }
    return self;
}

+ (LoginOperation *)loginOperationWithEmail:(NSString *)email password:(NSString *)password keepPendingPayment:(BOOL)keepPendingPayment
{
    return [[LoginOperation alloc] initWithEmail:email password:password keepPendingPayment:keepPendingPayment];
}

- (void)execute {
    MCLog(@"execute");

    NSString *path = [self addTokenToPath:kLoginPath];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"login"] = self.email;
    params[@"password"] = self.password;
    params[@"lifeTime"] = @"two_months";

    //Ensure no stale data is present before logging in.
    [self.objectModel clearUserRelatedDataKeepingPendingPayment:self.keepPendingPayment];
    
    __block __weak LoginOperation *weakSelf = self;
    [self setOperationSuccessHandler:^(NSDictionary *response) {
		weakSelf.responseHandler(nil, response);
	}];

    [self setOperationErrorHandler:^(NSError *error) {
        MCLog(@"Error:%@", error);
        weakSelf.responseHandler(error, nil);
    }];

    [self postData:params toPath:path];
}


@end
