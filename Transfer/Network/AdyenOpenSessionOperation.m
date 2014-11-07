//
//  AdyenOpenSessionOperation.m
//  Transfer
//
//  Created by Mats Trovik on 07/11/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "AdyenOpenSessionOperation.h"
#import "TransferwiseOperation+Private.h"
#import "NetworkErrorCodes.h"

#define kOpenSessionPath @"/openSession"

@interface AdyenOpenSessionOperation ()
@property (nonatomic,copy) NSString* paymentId;
@end

@implementation AdyenOpenSessionOperation

+(instancetype)operationWithPaymentId:(NSString*)paymentId resultHandler:(AdyenOpenSessionResultHandler)resultHandler;
{
    AdyenOpenSessionOperation *instance = [[AdyenOpenSessionOperation alloc] init];
    instance.paymentId = paymentId;
    instance.resultHandler = resultHandler;
    return instance;
}

-(void)execute {
    NSString *path = [self addTokenToPath:kOpenSessionPath];
    
    __weak typeof(self) weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.resultHandler(error,nil);
    }];
    
    [self setOperationSuccessHandler:^(NSDictionary *response) {
        NSString *url = response[@"url"];
        if (url) {
            weakSelf.resultHandler(nil,[NSURL URLWithString:url]);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:TRWErrorDomain code:ResponseServerError userInfo:response];
            weakSelf.resultHandler(error,nil);
        }
    }];
    
    NSDictionary *data = @{@"paymentId" : self.paymentId};
    [self postData:data toPath:path];
}


@end
