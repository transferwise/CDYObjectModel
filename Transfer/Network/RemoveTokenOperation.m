//
//  RemoveTokenOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 6/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RemoveTokenOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Constants.h"
#import "AuthenticationHelper.h"

NSString *const kReleaseTokenPath = @"/token/release";

@interface RemoveTokenOperation ()

@property (nonatomic, copy) NSString *token;

@end

@implementation RemoveTokenOperation

- (id)initWithToken:(NSString *)token {
    self = [super init];
    if (self) {
        _token = token;
    }
    return self;
}

- (void)execute {
    NSString *path = [self addTokenToPath:kReleaseTokenPath];

    [self setOperationErrorHandler:^(NSError *error) {
        MCLog(@"Remove token error:%@", error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        MCLog(@"Remove token success");
    }];

	if (self.token && self.token.length > 0)
	{
		[self postData:@{@"token" : self.token} toPath:path];
	}
}

@end
