//
//  ColoredButton.m
//  Transfer
//
//  Created by Juhan Hion on 18.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ColoredButton.h"
#import "MOMStyle.h"
#import "UIImage+Color.h"

@implementation ColoredButton

static __weak UIImage* normalStateImage;
static __weak UIImage* selectedStateImage;

#pragma mark - Init
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

#pragma mark - Setup
- (void)commonSetup
{
	//override in an inheriting class to customize
	//don't forget to call super in inheriging class
	
	if (self.addShadow)
    {
        [self setBackgroundImagesWithShadow];
    }
}

- (void)configureWithCompoundStyle:(NSString *)compoundStyle
{
	self.compoundStyle = compoundStyle;
	self.exclusiveTouch = YES;
}

-(void)configureWithTitleColor:(NSString *)titleColor
					 titleFont:(NSString *)titleFont
						 color:(NSString *)color
				highlightColor:(NSString *)highlightColor
{
    NSString *fontStyle;
	if (titleColor && titleFont)
	{
		fontStyle = [NSString stringWithFormat:@"%@.%@",titleFont,titleColor];
	}
    else
    {
        fontStyle = titleFont?:titleColor;
    }
	if (fontStyle)
	{
		self.fontStyle = fontStyle;
	}
	if (color != nil)
	{
		self.bgStyle = color;
	}
	if (highlightColor != nil)
	{
		self.highlightedBgStyle = highlightColor;
	}
    self.exclusiveTouch = YES;
}

#pragma mark - Properties
-(void)setAddShadow:(BOOL)addShadow
{
    _addShadow = addShadow;
    
    if(self.addShadow)
    {
		[self setBackgroundImagesWithShadow];
    }
    else
    {
        //reapply style
		self.compoundStyle = @"greenButton";
    }
}

-(void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];
    if(self.addShadow)
    {
        if (highlighted)
        {
            self.contentEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0);
        }
        else
        {
            self.contentEdgeInsets = UIEdgeInsetsZero;
        }
    }
}

#pragma mark - Helpers
- (void)setBackgroundImagesWithShadow
{
	// set background images
	[self setBackgroundImage:[self normalStateImage] forState:UIControlStateNormal];
	[self setBackgroundImage:[self selectedStateImage] forState:UIControlStateHighlighted];
}

-(UIImage*)normalStateImage
{
    return [ColoredButton getBackgroundImage:NO];
}

-(UIImage*)selectedStateImage
{
    return [ColoredButton getBackgroundImage:YES];
}

+ (UIImage *)getBackgroundImage:(BOOL)selected
{
	UIImage *result = selected ? selectedStateImage : normalStateImage;
	
	if (!result)
	{
		CGFloat scale = [[UIScreen mainScreen] scale];
        CGSize size = CGSizeMake(3.0f, 8.0f);
		
		CGRect mainRect = CGRectMake(0.0f, selected ? 2.0f : 0.0f, 3.0f, 4.0f);
        CGRect shadowRect = CGRectMake(0.0f, selected ? 6.0f : 4.0f, 3.0f, selected ? 2.0f : 4.0f);
		
		UIColor* greenColor = selected ? [UIColor colorFromStyle:@"greenSelected"] : [UIColor colorFromStyle:@"green"];
        UIColor* greenShadow = [UIColor colorFromStyle:@"greenShadow"];
		
		UIGraphicsBeginImageContextWithOptions(size, selected ? NO : YES, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [greenColor CGColor]);
        CGContextFillRect(context, mainRect);
        CGContextSetFillColorWithColor(context, [greenShadow CGColor]);
        CGContextFillRect(context, shadowRect);
        
        CGImageRef cgImage = CGBitmapContextCreateImage(context);
        UIImage* image = [UIImage imageWithCGImage:cgImage scale:scale orientation:UIImageOrientationUp];
        CGImageRelease(cgImage);
        UIGraphicsEndImageContext();
		
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(3, 1, 4, 1)];
        result = image;
		
        if (selected)
		{
			selectedStateImage = image;
		}
		else
		{
			normalStateImage = image;
		}
	}
	
	return result;
}
@end
