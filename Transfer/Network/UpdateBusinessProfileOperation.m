//
//  UpdateBusinessProfileOperation.m
//  Transfer
//
//  Created by Henri Mägi on 01.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "UpdateBusinessProfileOperation.h"
#import "TransferwiseOperation+Private.h"
#import "TransferwiseClient.h"
#import "ProfileDetails.h"

NSString *const kUpdateBusinessProfilePath = @"/user/updateBusinessProfile";
@interface UpdateBusinessProfileOperation ()

@property (strong, nonatomic)NSDictionary* dict;

@end

@implementation UpdateBusinessProfileOperation

- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        _dict = dict;
    }
    return self;
}

+ (UpdateBusinessProfileOperation *)updateWithWithDictionary:(NSDictionary *)dict completionHandler:(TWUpdateBusinessDetailsHandler)handler
{
    return [[UpdateBusinessProfileOperation alloc] initWithDictionary:dict];
}

- (void)execute {
    /*__block __weak UpdateBusinessProfileOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        MCLog(@"Error %@", error);
        weakSelf.completionHandler(error);
    }];
    [self setOperationSuccessHandler:^(NSDictionary *response) {
        weakSelf.completionHandler(handler);
    }];*/
    
    __block __weak UpdateBusinessProfileOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        MCLog(@"Error %@", error);
        weakSelf.completionHandler(nil, error);
    }];
    
    [self setOperationSuccessHandler:^(NSDictionary *response) {
        ProfileDetails *details = [ProfileDetails detailsWithData:response];
        weakSelf.completionHandler(details, nil);
    }];
    
    NSString *fullPath = [self addTokenToPath:kUpdateBusinessProfilePath];
    
    [self putData:self.dict toPath:fullPath];
}

@end
