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
	self.fontStyle = @"medium.@16.darkText2";
	MOMBasicStyle* fontStyle = (MOMBasicStyle*)[MOMStyleFactory getStyleForIdentifier:@"medium.@13"];
	self.floatingLabelFont = [fontStyle font];
	self.floatingLabelTextColor = [UIColor colorFromStyle:@"lightText2"];
	self.floatingLabelActiveTextColor =  [UIColor colorFromStyle:@"navBarBlue"];
	self.floatingLabelYPadding = @(2.0f);
}

- (void)configureWithTitle:(NSString *)title value:(NSString *)value
{
    [self setPlaceholder:title];
    [self setText:value];
}

@end
