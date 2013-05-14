//
//  StatesOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/14/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "StatesOperation.h"
#import "TransferwiseOperation+Private.h"
#import "USState.h"

NSString *const kListStatesPath = @"/recipient/listUsStates";

@implementation StatesOperation

- (void)execute {
    NSString *path = [self addTokenToPath:kListStatesPath];

    __block __weak StatesOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.completionHandler(nil, error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        NSArray *states = response[@"usStates"];
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:[states count]];
        for (NSDictionary *data in states) {
            USState *state = [USState stateWithData:data];
            [result addObject:state];
        }

        weakSelf.completionHandler([NSArray arrayWithArray:result], nil);
    }];

    [self getDataFromPath:path];
}

+ (StatesOperation *)operation {
    return [[StatesOperation alloc] init];
}

@end
