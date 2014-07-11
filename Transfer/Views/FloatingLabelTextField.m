//
//  FloatingLabelTextField.m
//  Transfer
//
//  Created by Juhan Hion on 09.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "FloatingLabelTextField.h"
#import "UIView+MOMStyle.h"
#import "UIColor+MOMStyle.h"
#import "MOMStyleFactory.h"
#import "MOMBasicStyle.h"
#import "Constants.h"

@implementation FloatingLabelTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        [self commonSetup];
    }
    return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self commonSetup];
}

- (void)commonSetup
{
    BOOL isIpad = IPAD;
	self.fontStyle = @"heavy.@{16,19}.DarkFont";
    //Placeholder? Corefont
    //medium
	MOMBasicStyle* fontStyle = (MOMBasicStyle*)[MOMStyleFactory getStyleForIdentifier:isIpad?@"medium.@16":@"medium.@13"];
	self.floatingLabelFont = [fontStyle font];
	self.floatingLabelTextColor = [UIColor colorFromStyle:@"CoreFont"];
	self.floatingLabelActiveTextColor =  [UIColor colorFromStyle:@"TWElectricBlue"];
	self.floatingLabelYPadding = @(2.0f);
}

- (void)configureWithTitle:(NSString *)title value:(NSString *)value
{
    [self setPlaceholder:title];
    [self setText:value];
}

@end
