//
//  NSString+Presentation.h
//  Transfer
//
//  Created by Jaanus Siim on 7/31/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Presentation)

- (NSString *)stripPattern:(NSString *)pattern;
- (NSString *)applyPattern:(NSString *)pattern;
- (NSString *)stringByRemovingPatterChar:(NSString *)pattern;
- (NSString *)stringByAddingPatternChar:(NSString *)pattern;
- (NSString *)moneyFormatting;

@end
