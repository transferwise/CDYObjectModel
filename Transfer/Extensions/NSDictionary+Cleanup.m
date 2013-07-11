//
//  NSDictionary+Cleanup.m
//  Transfer
//
//  Created by Jaanus Siim on 6/28/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "NSDictionary+Cleanup.h"

@implementation NSDictionary (Cleanup)

- (NSDictionary *)dictionaryByRemovingNullObjects {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:[self count]];

    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSNull class]]) {
            return;
        }

        result[key] = obj;
    }];

    return [NSDictionary dictionaryWithDictionary:result];
}


@end
