//
//  EmailCheckOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/31/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "EmailCheckOperation.h"
#import "TransferwiseOperation+Private.h"

NSString *const kEmailCheckPath = @"/account/checkEmail";

@interface EmailCheckOperation ()

@property (nonatomic, copy) NSString *email;

@end

@implementation EmailCheckOperation

- (id)initWithEmail:(NSString *)email {
    self = [super init];
    if (self) {
        _email = email;
    }
    return self;
}

- (void)execute {
    __block __weak EmailCheckOperation *weakSelf = self;
    NSString *path = [self addTokenToPath:kEmailCheckPath];

    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.resultHandler(NO, error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        BOOL available = [response[@"available"] boolValue];
        weakSelf.resultHandler(available, nil);
    }];

    [self getDataFromPath:path params:@{@"email" : self.email}];
}

+ (EmailCheckOperation *)operationWithEmail:(NSString *)email {
    return [[EmailCheckOperation alloc] initWithEmail:email];
}

@end
