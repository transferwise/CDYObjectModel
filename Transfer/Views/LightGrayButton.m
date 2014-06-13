//
//  LightGrayButton.m
//  Transfer
//
//  Created by Juhan Hion on 13.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "LightGrayButton.h"
#import "UIFont+MOMStyle.h"
#import "UIColor+MOMStyle.h"
#import "UIImage+Color.h"

@implementation LightGrayButton

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
    [self setTitleColor:[UIColor colorFromStyle:@"lighterBlue"] forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont fontFromStyle:@"heavy.@17"]];
	[self setBackgroundImage:[UIImage imageFromColor:[UIColor colorFromStyle:@"cellSelected"]] forState:UIControlStateNormal];
    self.exclusiveTouch = YES;
}

@end
