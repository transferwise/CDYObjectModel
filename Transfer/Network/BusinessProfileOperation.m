//
//  UpdateBusinessProfileOperation.m
//  Transfer
//
//  Created by Henri Mägi on 01.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "BusinessProfileOperation.h"
#import "TransferwiseOperation+Private.h"
#import "ProfileDetails.h"
#import "Credentials.h"
#import "BusinessProfileInput.h"

NSString *const kUpdateBusinessProfilePath = @"/user/updateBusinessProfile";
@interface BusinessProfileOperation ()

@property (strong, nonatomic) BusinessProfileInput *data;

@end

@implementation BusinessProfileOperation

- (id)initWithData:(BusinessProfileInput *)data {
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

- (void)execute {
    NSString *path = [self addTokenToPath:kUpdateBusinessProfilePath];
    
    __block __weak BusinessProfileOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.saveResultHandler(nil, error);
    }];
    
    [self setOperationSuccessHandler:^(NSDictionary *response) {
        ProfileDetails *details = [ProfileDetails detailsWithData:response];
        [Credentials setDisplayName:[details displayName]];
        weakSelf.saveResultHandler(details, nil);
    }];
    
    [self postData:[self.data data] toPath:path];
}

+ (BusinessProfileOperation *)commitWithData:(BusinessProfileInput *)data {
    return [[BusinessProfileOperation alloc] initWithData:data];
}


@end
