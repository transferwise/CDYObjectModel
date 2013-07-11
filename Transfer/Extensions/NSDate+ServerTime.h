//
//  NSDate+ServerTime.h
//  Transfer
//
//  Created by Jaanus Siim on 6/28/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ServerTime)

+ (NSDate *)dateFromServerString:(NSString *)dateString;

@end
