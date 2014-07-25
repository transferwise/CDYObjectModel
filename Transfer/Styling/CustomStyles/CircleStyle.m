//
//  CircleStyle.m
//  Transfer
//
//  Created by Mats Trovik on 24/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "CircleStyle.h"

@implementation CircleStyle

-(ApplyAppearanceBlock)apperanceBlock
{
    return ^void(UIView* view){
    view.layer.cornerRadius = view.frame.size.width/2.0f;
    view.layer.masksToBounds = YES;
    };
}

@end
