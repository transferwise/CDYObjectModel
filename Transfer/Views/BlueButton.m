//
//  BlueButton.m
//  Transfer
//
//  Created by Juhan Hion on 17.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "BlueButton.h"
#import "UIFont+MOMStyle.h"
#import "UIColor+MOMStyle.h"
#import "UIImage+Color.h"

@implementation BlueButton

- (id)initWithFrame:(CGRect)frame
{
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
    [self setTitleColor:[UIColor colorFromStyle:@"white"] forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont fontFromStyle:@"medium.@16"]];
	[self setBackgroundImage:[UIImage imageFromColor:[UIColor colorFromStyle:@"lightBlue3"]] forState:UIControlStateNormal];
	[self setBackgroundImage:[UIImage imageFromColor:[UIColor colorFromStyle:@"blue"]] forState:UIControlStateHighlighted];
    self.exclusiveTouch = YES;
}

@end
