//
//  NSDate+ServerTime.m
//  Transfer
//
//  Created by Jaanus Siim on 6/28/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "NSDate+ServerTime.h"

@implementation NSDate (ServerTime)

static NSDateFormatter *__dateFormatter;
+ (NSDate *)dateFromServerString:(NSString *)dateString {
    if (!dateString || [dateString isKindOfClass:[NSNull class]]) {
        return nil;
    }

    if (!__dateFormatter) {
        __dateFormatter = [[NSDateFormatter alloc] init];
        [__dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [__dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/London"]];
    }

    return [__dateFormatter dateFromString:dateString];
}

@end
