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
    [self.titleLabel setFont:[UIFont fontFromStyle:@"medium.@17"]];
	[self setBackgroundImage:[UIImage imageFromColor:[UIColor colorFromStyle:@"cellSelected"]] forState:UIControlStateNormal];
    self.exclusiveTouch = YES;
	self.layer.borderWidth = 1.f;
	self.layer.cornerRadius = 2.f;
	self.layer.masksToBounds = YES;
	self.layer.borderColor = [[UIColor colorFromStyle:@"lightGray"] CGColor];
}

@end
