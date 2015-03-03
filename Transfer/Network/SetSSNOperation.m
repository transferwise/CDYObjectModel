//
//  setSSNOperation.m
//  Transfer
//
//  Created by Mats Trovik on 15/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "SetSSNOperation.h"
#import "TransferwiseOperation+Private.h"
#import "NetworkErrorCodes.h"

NSString *const SetSSNErrorDomain = @"SSNError";

@interface SetSSNOperation ()

@property (nonatomic, copy) NSString *ssn;
@property (nonatomic, copy) void(^resultHandler)(NSError* error) ;

@end

@implementation SetSSNOperation

NSString *const kSetSSNPath = @"/verification/setSSN";

+(instancetype)operationWithSsn:(NSString*)ssn resultHandler:(void(^)(NSError* error))resultHandler;
{
    SetSSNOperation *instance = [[SetSSNOperation alloc] init];
    instance.ssn = ssn;
    instance.resultHandler =resultHandler;
    return instance;
}

-(void)execute {
    
    
    __weak typeof(self) weakSelf = self;
    
    if(!self.ssn)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [[NSError alloc] initWithDomain:SetSSNErrorDomain code:SSN_MISSING userInfo:nil];
            weakSelf.resultHandler(error);
        });
        return;
    }
    
    NSString *path = [self addTokenToPath:kSetSSNPath];
    
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.resultHandler(error);
    }];
    
    [self setOperationSuccessHandler:^(NSDictionary *response) {
        NSString *status = response[@"status"];
        if ([@"success" isEqualToString:status]) {
            weakSelf.resultHandler(nil);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:TRWErrorDomain code:ResponseServerError userInfo:response];
            weakSelf.resultHandler(error);
        }
    }];
    
    NSDictionary *data = @{@"ssn" : self.ssn};
    [self postData:data toPath:path];
}

@end
