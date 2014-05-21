//
//  MOMRoundedCornerStyle.m
//  StyleTest
//
//  Created by Mats Trovik on 14/02/2014.
//  Copyright (c) 2014 Matsomatic. All rights reserved.
//

#import "MOMRoundedCornerStyle.h"

@implementation MOMRoundedCornerStyle

-(ApplyAppearanceBlock)apperanceBlock
{
    return ^void(UIView* view){
        view.layer.cornerRadius = [self.radius floatValue];
        view.layer.masksToBounds = YES;
    };
}

@end
