//
//  StatesOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/14/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^StatesBlock)(NSArray *states, NSError *error);

@interface StatesOperation : TransferwiseOperation

@property (nonatomic, copy) StatesBlock completionHandler;

+ (StatesOperation *)operation;

@end
