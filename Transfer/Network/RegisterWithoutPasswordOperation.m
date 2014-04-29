//
//  RegisterWithoutPasswordOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 6/4/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RegisterWithoutPasswordOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Credentials.h"
#import "ObjectModel+RecipientTypes.h"
#import "ObjectModel+Users.h"

NSString *const kRegisterPasslessPath = @"/account/registerWithNoPassword";

@interface RegisterWithoutPasswordOperation ()

@property (nonatomic, copy) NSString *email;

@end

@implementation RegisterWithoutPasswordOperation

- (id)initWithEmail:(NSString *)email {
    self = [super init];
    if (self) {
        _email = email;
    }
    return self;
}

- (void)execute {
    NSString *path = [self addTokenToPath:kRegisterPasslessPath];

    __block __weak RegisterWithoutPasswordOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.completionHandler(error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        [weakSelf.workModel performBlock:^{
            NSString *token = response[@"token"];
            if ([token isKindOfClass:[NSDictionary class]]) {
                token = response[@"token"][@"value"];
            }
            [Credentials setUserToken:token];
            [Credentials setUserSecret:response[@"secret"]];
            [Credentials setUserEmail:weakSelf.email];

            [weakSelf.workModel markAnonUserWithEmail:weakSelf.email];
            [weakSelf.workModel saveContext:^{
                weakSelf.completionHandler(nil);
            }];
        }];
    }];

    [self postData:@{@"email":self.email} toPath:path];
}

+ (RegisterWithoutPasswordOperation *)operationWithEmail:(NSString *)email {
    return [[RegisterWithoutPasswordOperation alloc] initWithEmail:email];
}

@end
