//
//  GreenButton.m
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "GreenButton.h"
#import "UIButton+Skinning.h"
#import "MOMStyle.h"
#import "Constants.h"

@implementation GreenButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonSetup];

}

-(void)commonSetup
{

    self.compoundStyle = @"greenButton";
    
    if(IPAD)
    {
        [self setBackgroundImage:[UIImage imageNamed:@"GreenButton"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"GreenButtonSelected"] forState:UIControlStateHighlighted];
    }
    
    self.exclusiveTouch = YES;
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
     if(IPAD)
     {
         if(highlighted)
         {
             self.contentEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
         }
         else
         {
        self.contentEdgeInsets = UIEdgeInsetsZero;
         }
     }
}

@end
