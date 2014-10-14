//
//  NSString+Presentation.m
//  Transfer
//
//  Created by Jaanus Siim on 7/31/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "NSString+Presentation.h"
#import "MoneyFormatter.h"

@implementation NSString (Presentation)

- (NSString *)stripPattern:(NSString *)pattern {
    NSMutableString *result = [NSMutableString string];
    NSUInteger index = 0;
    while (index < [self length] && index < [pattern length]) {
        NSRange range = NSMakeRange(index, 1);
        NSString *entryChar = [self substringWithRange:range];
        NSString *patternChar = [pattern substringWithRange:range];

        if ([patternChar isEqualToString:@"*"]) {
            [result appendString:entryChar];
        }

        index++;
    }

    return [NSString stringWithString:result];
}

- (NSString *)applyPattern:(NSString *)pattern {
    NSMutableString *result = [NSMutableString string];

    NSUInteger patternIndex = 0;
    NSUInteger sourceIndex = 0;
    while (patternIndex < [pattern length] && sourceIndex < [self length]) {
        NSString *patternChar = [pattern substringWithRange:NSMakeRange(patternIndex, 1)];
        NSString *sourceChar = [self substringWithRange:NSMakeRange(sourceIndex, 1)];

        patternIndex++;
        if (![sourceChar isEqualToString:patternChar] && [patternChar isEqualToString:@"-"]) {
            [result appendString:patternChar];
            continue;
        }

        [result appendString:sourceChar];

        sourceIndex++;
    }

    if (patternIndex < [pattern length]) {
        NSString *patternChar = [pattern substringWithRange:NSMakeRange(patternIndex, 1)];
        if ([patternChar isEqualToString:@"-"]) {
            [result appendString:patternChar];
        }
    }

    if (sourceIndex < [self length]) {
        [result appendString:[self substringFromIndex:sourceIndex]];
    }

    return [NSString stringWithString:result];
}

- (NSString *)stringByRemovingPatterChar:(NSString *)pattern {
    if ([self length] == 0) {
        return self;
    }

    NSUInteger index = [self length];
    if (index > [pattern length]) {
        return self;
    }

    NSString *patternChar = [pattern substringWithRange:NSMakeRange(index - 1, 1)];
    if (![patternChar isEqualToString:@"*"]) {
        return [self substringToIndex:index - 1];
    }

    return self;
}

- (NSString *)stringByAddingPatternChar:(NSString *)pattern {
    NSUInteger index = [self length];
    if (index >= [pattern length]) {
        return self;
    }

    NSString *patternChar = [pattern substringWithRange:NSMakeRange(index, 1)];
    if (![patternChar isEqualToString:@"*"]) {
        return [self stringByAppendingString:patternChar];
    }

    return self;
}

- (NSString *)moneyFormatting {
	NSString* workingCopy = [self copy];
    [workingCopy stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSString *cents = @"";
    NSRange dotLocation = [workingCopy rangeOfString:@"."];
    if (dotLocation.location != NSNotFound) {
        cents = [workingCopy substringFromIndex:dotLocation.location];
    }

    NSString *money = [workingCopy stringByReplacingOccurrencesOfString:cents withString:@""];
    money = [money stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSNumber *moneyNumber = [[MoneyFormatter sharedInstance] numberFromString:money];
    NSString *formatted = [[MoneyFormatter sharedInstance] formatAmount:moneyNumber];

    formatted = [formatted stringByReplacingOccurrencesOfString:@".00" withString:cents];

    return formatted;
}

- (NSString *)getInitials
{
 
    NSMutableString* result = [NSMutableString string];
    NSArray *components = [self componentsSeparatedByString:@" "];
    components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    
    if([components count] > 2)
    {
        components = @[components[0],[components lastObject]];
    }
    
    for(NSString* component in components)
    {
        [result appendString:[[component substringToIndex:1] uppercaseString]];
    }
    
    return [NSString stringWithString:result];
}

@end
