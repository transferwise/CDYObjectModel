//
//  UIFont+MOMStyle.m
//  Transfer
//
//  Created by Juhan Hion on 11.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "UIFont+MOMStyle.h"
#import "MOMStyleFactory.h"
#import "MOMBasicStyle.h"

@implementation UIFont (MOMStyle)

+(UIFont*)fontFromStyle:(NSString *)styleIdentifier
{
	UIFont* result;
    MOMBaseStyle* style = [MOMStyleFactory getStyleForIdentifier:styleIdentifier];
    if([style isKindOfClass:[MOMBasicStyle class]])
    {
		MOMBasicStyle* basicStyle = (MOMBasicStyle*)style;
		
		result = [UIFont fontWithName:basicStyle.fontName size:[basicStyle.fontSize floatValue]];
    }
    return result;
}

@end
