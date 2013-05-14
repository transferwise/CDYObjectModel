//
//  USState.m
//  Transfer
//
//  Created by Jaanus Siim on 5/14/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "USState.h"

@interface USState ()

@property (nonatomic, copy) NSString *name;

@end

@implementation USState

+ (USState *)stateWithData:(NSDictionary *)data {
    USState *state = [[USState alloc] init];
    [state setName:data[@"name"]];
    return state;
}

@end
