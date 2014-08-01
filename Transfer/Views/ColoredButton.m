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

@property (strong, nonatomic) NSString* compoundStyleName;
@property (strong, nonatomic) MOMCompoundStyle* compoundStyleContainer;
@property (strong, nonatomic) NSString* shadowColor;
@property (weak, nonatomic) UIImage* normalStateImage;
@property (weak, nonatomic) UIImage* selectedStateImage;
@property (nonatomic, assign) CGSize lastDrawnSize;

@end

@implementation ColoredButton

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

- (id)init
{
	self = [super init];
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
        [self setBackgroundImages];
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
	//save style name
	self.compoundStyleName = compoundStyle;
	
	self.exclusiveTouch = YES;
	self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Properties
- (void)setHighlighted:(BOOL)highlighted
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

- (void)setAddShadow:(BOOL)addShadow
{
	_addShadow = addShadow;
	
	if(!addShadow)
	{
		self.compoundStyle = self.compoundStyleName;
	}
}

-(void)setProgress:(CGFloat)progress
{
    if(_progress != progress)
    {
        _progress = progress;
        [self setBackgroundImages];
    }
}

#pragma mark - Helpers
-(void)layoutSubviews
{
    if(self.bounds.size.width != self.lastDrawnSize.width  || self.bounds.size.height != self.lastDrawnSize.height)
    {
        [self setBackgroundImages];
    }
    [super layoutSubviews];
}

- (void)setBackgroundImages
{
	UIColor* bgStyle = [self getColorFromStyle:self.compoundStyleContainer.bgStyle];
	UIColor* highlightedBgStyle = [self getColorFromStyle:self.compoundStyleContainer.highlightedBgStyle];
	
	//this gets called from layoutsubviews
	//colors might noth have been set yet.
	if(bgStyle && highlightedBgStyle)
	{
		// set background images
		[self setBackgroundImage:[self getBackgroundImage:NO
												  bgStyle:bgStyle
									   highlightedBgStyle:highlightedBgStyle
											   shdowStyle:self.shadowColor]
						forState:UIControlStateNormal];
		[self setBackgroundImage:[self getBackgroundImage:YES
												  bgStyle:bgStyle
									   highlightedBgStyle:highlightedBgStyle
											   shdowStyle:self.shadowColor]
						forState:UIControlStateHighlighted];
		
		self.lastDrawnSize = self.bounds.size;
	}
}

- (UIImage *)getBackgroundImage:(BOOL)selected
						bgStyle:(UIColor *)bgStyle
			 highlightedBgStyle:(UIColor *)highlightedBgStyle
					 shdowStyle:(NSString *)shadowStyle
{
	UIImage *result = selected ? self.selectedStateImage : self.normalStateImage;
	
	if (!result)
	{
		CGSize size = self.bounds.size;
		CGFloat scale = [[UIScreen mainScreen] scale];
		CGRect rect = CGRectMake(0, 0, size.width, size.height);
		
		CGRect progressRect = rect;
		progressRect.size.width = round(self.progress * size.width);
		
		CGRect remainingRect = rect;
		remainingRect.size.width = size.width - progressRect.size.width ;
		remainingRect.origin.x = progressRect.size.width;
		
		UIColor* progressColor = highlightedBgStyle;
		UIColor* remainingColor = bgStyle;
		UIColor* progressSelected = highlightedBgStyle;
		UIColor* remainingSelected = highlightedBgStyle;
		
		UIGraphicsBeginImageContextWithOptions(size, selected ? NO : YES, 0.0);
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetFillColorWithColor(context, selected ? [progressSelected CGColor] : [progressColor CGColor]);
		CGContextFillRect(context, progressRect);
		CGContextSetFillColorWithColor(context, selected ? [remainingSelected CGColor] : [remainingColor CGColor]);
		CGContextFillRect(context, remainingRect);
		
		if(self.addShadow)
		{
			CGRect progressShadowRect = progressRect;
			
			if (selected)
			{
				progressRect.origin.y += 2.0f;
				progressRect.origin.y += 2.0f;
			}
			
			progressShadowRect.origin.y = size.height - (selected ? 2.0f : 4.0f);
			progressShadowRect.size.height = selected ? 2.0f : 4.0f;
			
			CGRect remainingShadowRect = remainingRect;
			remainingShadowRect.origin.y = size.height - (selected ? 2.0f : 4.0f);
			remainingShadowRect.size.height = selected ? 2.0f : 4.0f;
			
			UIColor* progressShadow = [UIColor colorFromStyle:shadowStyle];
			UIColor* remainingShadow = [UIColor colorFromStyle:shadowStyle];
			
			CGContextSetFillColorWithColor(context, [progressShadow CGColor]);
			CGContextFillRect(context, progressShadowRect);
			CGContextSetFillColorWithColor(context, [remainingShadow CGColor]);
			CGContextFillRect(context, remainingShadowRect);
			
			if (selected)
			{
				CGRect alphaRect = rect;
				alphaRect.origin.y =0.0f;
				alphaRect.size.height = 2.0f;
				
				CGContextBeginTransparencyLayer(context, NULL);
				CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
				CGContextFillRect(context, alphaRect);
				CGContextEndTransparencyLayer(context);
			}
		}
		else if(selected)
		{
			CGContextSetFillColorWithColor(context, [progressSelected CGColor]);
			CGContextFillRect(context, progressRect);
			CGContextSetFillColorWithColor(context, [remainingSelected CGColor]);
			CGContextFillRect(context, remainingRect);
		}
		
		CGImageRef cgImage = CGBitmapContextCreateImage(context);
		UIImage* image = [UIImage imageWithCGImage:cgImage scale:scale orientation:UIImageOrientationUp];
		CGImageRelease(cgImage);
		
		result = image;
		
        if (selected)
		{
			self.selectedStateImage = image;
		}
		else
		{
			self.normalStateImage = image;
		}
		
		UIGraphicsEndImageContext();
		
		self.lastDrawnSize = self.bounds.size;
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
