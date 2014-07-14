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

@interface ColoredButton ()

@property (strong, nonatomic) MOMCompoundStyle* compoundStyleContainer;
@property (strong, nonatomic) NSString* shadowColor;

@end

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
	//don't forget to call super in inheriting class
	
	if (self.addShadow)
    {
        [self setBackgroundImagesWithShadow];
    }
}

- (void)configureWithCompoundStyle:(NSString *)compoundStyle
{
	[self configureWithCompoundStyle:compoundStyle
						 shadowColor:nil];
}

- (void)configureWithCompoundStyle:(NSString *)compoundStyle
					   shadowColor:(NSString *)shadowColor
{
	//apply style
	self.compoundStyle = compoundStyle;
	//save shadow color
	self.shadowColor = shadowColor;
	//get style to get to actual colors later
	self.compoundStyleContainer = [MOMStyleFactory compoundStyleForIdentifier:compoundStyle];
	
	self.exclusiveTouch = YES;
}

#pragma mark - Properties
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

- (UIImage*)normalStateImage
{
    return [ColoredButton getBackgroundImage:NO
									 bgStyle:[self getColorFromStyle:self.compoundStyleContainer.bgStyle]
						  highlightedBgStyle:[self getColorFromStyle:self.compoundStyleContainer.highlightedBgStyle]
								  shdowStyle:self.shadowColor];
}

- (UIImage*)selectedStateImage
{
    return [ColoredButton getBackgroundImage:YES
									 bgStyle:[self getColorFromStyle:self.compoundStyleContainer.bgStyle]
						  highlightedBgStyle:[self getColorFromStyle:self.compoundStyleContainer.highlightedBgStyle]
								  shdowStyle:self.shadowColor];
}

+ (UIImage *)getBackgroundImage:(BOOL)selected
						bgStyle:(UIColor *)bgStyle
			 highlightedBgStyle:(UIColor *)highlightedBgStyle
					 shdowStyle:(NSString *)shadowStyle
{
	UIImage *result = selected ? selectedStateImage : normalStateImage;
	
	if (!result)
	{
		CGFloat scale = [[UIScreen mainScreen] scale];
        CGSize size = CGSizeMake(3.0f, 8.0f);
		
		CGRect mainRect = CGRectMake(0.0f, selected ? 2.0f : 0.0f, 3.0f, 4.0f);
        CGRect shadowRect = CGRectMake(0.0f, selected ? 6.0f : 4.0f, 3.0f, selected ? 2.0f : 4.0f);
		
		UIColor* bgColor = selected ? highlightedBgStyle : bgStyle;
        UIColor* shadowColor = [UIColor colorFromStyle:shadowStyle];
		
		UIGraphicsBeginImageContextWithOptions(size, selected ? NO : YES, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [bgColor CGColor]);
        CGContextFillRect(context, mainRect);
        CGContextSetFillColorWithColor(context, [shadowColor CGColor]);
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

- (UIColor *)getColorFromStyle:(MOMBaseStyle *)style
{
	if([style isKindOfClass:[MOMBaseStyle class]])
	{
		return ((MOMBasicStyle *)style).color;
	}
	
	return nil;
}
@end
