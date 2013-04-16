//
//  NSDictionary+SensibleData.m
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "NSDictionary+SensibleData.h"

@implementation NSDictionary (SensibleData)

- (NSDictionary *)sensibleDataHidden {
    NSMutableDictionary *data = [self mutableCopy];
    if ([data objectForKey:@"password"]) {
        [data setObject:@"********" forKey:@"password"];
    }

    return [NSDictionary dictionaryWithDictionary:data];
}

@end
