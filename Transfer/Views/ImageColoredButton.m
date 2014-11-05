//
//  ImageColoredButton.m
//  Transfer
//
//  Created by Juhan Hion on 14.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ImageColoredButton.h"
#import "Constants.h"

@implementation ImageColoredButton

- (void)configureWithCompoundStyle:(NSString *)compoundStyle
					   shadowColor:(NSString *)shadowColor
						 imageName:(NSString *)imageName
{
	[super configureWithCompoundStyle:compoundStyle
						  shadowColor:shadowColor];
    UIImage *image = [UIImage imageNamed:imageName];
	[self setImage:image forState:UIControlStateNormal];
    [super commonSetup];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    UIImage *image = [self imageForState:UIControlStateNormal];
    CGSize textSize = [[self titleForState:UIControlStateNormal] sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGFloat imagePadding = (self.bounds.size.width-textSize.width)/2.0f - image.size.width;
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, -imagePadding, 0 ,imagePadding)];
    if(IPAD)
    {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width/2.0f, 0 ,image.size.width/
                                                  2.0f)];
    }
}

@end
