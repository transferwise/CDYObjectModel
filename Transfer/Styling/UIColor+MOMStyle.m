//
//  UIColor+MOMStyle.m
//  Transfer
//
//  Created by Mats Trovik on 21/05/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "UIColor+MOMStyle.h"
#import "MOMStyleFactory.h"
#import "MOMBasicStyle.h"

@implementation UIColor (MOMStyle)

+(UIColor*)colorFromStyle:(NSString*)styleIdentifier
{
    UIColor* result;
    MOMBaseStyle* style = [MOMStyleFactory getStyleForIdentifier:styleIdentifier];
    if([style isKindOfClass:[MOMBasicStyle class]])
    {
        result = [((MOMBasicStyle*) style) color];
    }
    return result;
}

@end
