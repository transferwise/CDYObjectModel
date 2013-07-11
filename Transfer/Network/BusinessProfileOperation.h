//
//  UpdateBusinessProfileOperation.h
//  Transfer
//
//  Created by Henri Mägi on 01.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"
#import "UserDetailsOperation.h"

@class PlainBusinessProfileInput;

@interface BusinessProfileOperation : TransferwiseOperation

@property (nonatomic, copy) TWProfileDetailsHandler saveResultHandler;

+ (BusinessProfileOperation *)commitWithData:(PlainBusinessProfileInput *)data;
+ (BusinessProfileOperation *)validateWithData:(PlainBusinessProfileInput *)data;

@end
