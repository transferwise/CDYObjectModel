//
//  NSString+MOMColorStyle.m
//  StyleTest
//
//  Created by Mats Trovik on 14/02/2014.
//  Copyright (c) 2014 Matsomatic. All rights reserved.
//

#import "NSString+MOMStyle.h"

@implementation NSString (MOMStyle)

-(void)mapHexToRedNumber:(NSNumber* __strong*)red greenNumber:(NSNumber* __strong*)green blueNumber:(NSNumber* __strong*)blue alphaNumber:(NSNumber* __strong*)alpha
{
    NSString *hexString = [self stringByReplacingOccurrencesOfString:@"#" withString:@""];
    hexString = [hexString stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    if([hexString length]>=6)
    {
        NSString* redString = [hexString substringWithRange:NSMakeRange(0, 2)];
        NSString* greenString = [hexString substringWithRange:NSMakeRange(2, 2)];
        NSString* blueString = [hexString substringWithRange:NSMakeRange(4, 2)];
        
        uint r,g,b;
        
        NSScanner* scanner= [NSScanner scannerWithString:redString];
        if(![scanner scanHexInt:&r]) return;
        scanner= [NSScanner scannerWithString:greenString];
        if(![scanner scanHexInt:&g]) return;
        scanner= [NSScanner scannerWithString:blueString];
        if(![scanner scanHexInt:&b]) return;
        
        
        *red = @(r/255.0f);
        
        *green = @(g/255.0f);
        
        *blue = @(b/255.0f);
        
        
        if([hexString length]>=8)
        {
            uint a;
            NSString* alphaString = [hexString substringWithRange:NSMakeRange(6, 2)];
            scanner= [NSScanner scannerWithString:alphaString];
            if(![scanner scanHexInt:&a]) return;
            *alpha = @(a/255.0f);;
        }
    }
}


@end
