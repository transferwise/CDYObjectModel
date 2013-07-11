//
//  UpdateBusinessProfileOperation.m
//  Transfer
//
//  Created by Henri Mägi on 01.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "BusinessProfileOperation.h"
#import "TransferwiseOperation+Private.h"
#import "PlainProfileDetails.h"
#import "Credentials.h"
#import "PlainBusinessProfileInput.h"

NSString *const kUpdateBusinessProfilePath = @"/user/updateBusinessProfile";
NSString *const kValidateBusinessProfilePath = @"/user/validateBusinessProfile";

@interface BusinessProfileOperation ()

@property (strong, nonatomic) PlainBusinessProfileInput *data;
@property (nonatomic, copy) NSString *path;

@end

@implementation BusinessProfileOperation

- (id)initWithPath:(NSString *)path data:(PlainBusinessProfileInput *)data {
    self = [super init];
    if (self) {
        _data = data;
        _path = path;
    }
    return self;
}

- (void)execute {
    NSString *path = [self addTokenToPath:self.path];
    
    __block __weak BusinessProfileOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.saveResultHandler(nil, error);
    }];
    
    [self setOperationSuccessHandler:^(NSDictionary *response) {
        PlainProfileDetails *details = [PlainProfileDetails detailsWithData:response];
        if (details) {
            [Credentials setDisplayName:[details displayName]];
        }
        weakSelf.saveResultHandler(details, nil);
    }];
    
    [self postData:[self.data data] toPath:path];
}

+ (BusinessProfileOperation *)commitWithData:(PlainBusinessProfileInput *)data {
    return [[BusinessProfileOperation alloc] initWithPath:kUpdateBusinessProfilePath data:data];
}

+ (BusinessProfileOperation *)validateWithData:(PlainBusinessProfileInput *)data {
    return [[BusinessProfileOperation alloc] initWithPath:kValidateBusinessProfilePath data:data];
}

@end
