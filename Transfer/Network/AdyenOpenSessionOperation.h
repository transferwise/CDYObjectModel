//
//  AdyenOpenSessionOperation.h
//  Transfer
//
//  Created by Mats Trovik on 07/11/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^AdyenOpenSessionResultHandler)(NSError *error, NSURL* url);

@interface AdyenOpenSessionOperation : TransferwiseOperation

@property (nonatomic,copy)AdyenOpenSessionResultHandler resultHandler;

@end
