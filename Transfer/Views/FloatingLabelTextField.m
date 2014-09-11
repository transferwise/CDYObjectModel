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

@interface FloatingLabelTextField ()

@property (nonatomic,strong)MOMBasicStyle* placeholderStyle;

@end

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
    
	self.fontStyle = @"heavy.@{17,20}.DarkFont";
    self.placeholderStyle = (MOMBasicStyle*)[MOMStyleFactory getStyleForIdentifier:@"medium.@{17,20}.Greygory"];
    
	MOMBasicStyle* fontStyle = (MOMBasicStyle*)[MOMStyleFactory getStyleForIdentifier:@"medium.@{14,16}"];
	self.floatingLabelFont = [fontStyle font];
	self.floatingLabelTextColor = [UIColor colorFromStyle:@"CoreFont"];
	self.floatingLabelActiveTextColor =  [UIColor colorFromStyle:@"TWElectricBlue"];
	self.floatingLabelYPadding = 1.0f;
}


- (void)drawPlaceholderInRect:(CGRect)rect {

    // We use self.font.pointSize in order to match the input text's font size
    [self.placeholder drawInRect:rect
                  withAttributes:@{NSForegroundColorAttributeName:[self.placeholderStyle color] , NSFontAttributeName:[self.placeholderStyle font]}];
}


- (void)configureWithTitle:(NSString *)title value:(NSString *)value
{
    self.placeholder = title;
    [self setText:value];
}

- (void)setTitle:(NSString *)title
{
	self.placeholder = title;
}

@end
