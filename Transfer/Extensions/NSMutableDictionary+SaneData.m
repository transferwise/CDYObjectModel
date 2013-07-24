//
//  NSMutableDictionary+SaneData.m
//  Transfer
//
//  Created by Jaanus Siim on 7/24/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "NSMutableDictionary+SaneData.h"

@implementation NSMutableDictionary (SaneData)

- (void)setNotNilValue:(id)value forKey:(NSString *)key {
    if (!value) {
        return;
    }

    self[key] = value;
}

@end
