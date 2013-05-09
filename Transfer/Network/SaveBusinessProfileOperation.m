//
//  UpdateBusinessProfileOperation.m
//  Transfer
//
//  Created by Henri Mägi on 01.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "SaveBusinessProfileOperation.h"
#import "TransferwiseOperation+Private.h"
#import "ProfileDetails.h"
#import "Credentials.h"

NSString *const kUpdateBusinessProfilePath = @"/user/updateBusinessProfile";
@interface SaveBusinessProfileOperation ()

@property (strong, nonatomic)NSDictionary* data;

@end

@implementation SaveBusinessProfileOperation

- (id)initWithData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

- (void)execute {
    NSString *path = [self addTokenToPath:kUpdateBusinessProfilePath];
    
    __block __weak SaveBusinessProfileOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.saveResultHandler(nil, error);
    }];
    
    [self setOperationSuccessHandler:^(NSDictionary *response) {
        ProfileDetails *details = [ProfileDetails detailsWithData:response];
        [Credentials setDisplayName:[details displayName]];
        weakSelf.saveResultHandler(details, nil);
    }];
    
    [self postData:self.data toPath:path];
}

+ (SaveBusinessProfileOperation *)operationWithData:(NSDictionary *)data {
    return [[SaveBusinessProfileOperation alloc] initWithData:data];
}


@end
