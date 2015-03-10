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
@property (weak, nonatomic) UIImage* highlightedStateImage;
@property (nonatomic, assign) CGSize lastDrawnSize;

@property (nonatomic, assign) BOOL isAnimatingProgress;
@property (nonatomic, strong) NSThread* animationThread;
@property (nonatomic, strong) CADisplayLink* displayLink;
@property (nonatomic, assign) CGFloat transitionalProgress;
@property (nonatomic, assign) CGFloat progressStartPoint;
@property (nonatomic, assign) CFTimeInterval startTime;

#define animationDuration (0.3f)

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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setProgress:0.2 animated:NO];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setProgress:0.8 animated:YES];
    });
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
	
	[self resetBackgroundImages];
	[self setBackgroundImages];
	
	if(!addShadow)
	{
		self.compoundStyle = self.compoundStyleName;
	}
}

-(void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    if(_progress != progress)
    {
        self.progressStartPoint = _progress;
        _progress = progress;
        if(!self.animationThread)
        {
            if(animated)
            {
                self.animationThread = [[NSThread alloc] initWithTarget:self selector:@selector(setupDisplayLink) object:nil];
                [self.animationThread start];
                
            }
            else
            {
                self.transitionalProgress = progress;
                [self resetBackgroundImages];
                [self setBackgroundImages];
            }
        }
    }
}

-(void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
}

-(void)animateProgressFrom:(CGFloat)startValue to:(CGFloat)toValue delay:(NSTimeInterval)delay
{
    [self setProgress:startValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setProgress:toValue animated:YES];
    });
}

#pragma mark - Helpers
-(void)layoutSubviews
{
    if(self.bounds.size.width != self.lastDrawnSize.width  || self.bounds.size.height != self.lastDrawnSize.height)
    {
		[self resetBackgroundImages];
        [self setBackgroundImages];
    }
    [super layoutSubviews];
}

- (void)resetBackgroundImages
{
	self.normalStateImage = nil;
	self.highlightedStateImage = nil;
}

- (void)setBackgroundImages
{
	UIColor* bgColor = [self getColorFromStyle:self.compoundStyleContainer.bgStyle];
	UIColor* highlightedBgColor = [self getColorFromStyle:self.compoundStyleContainer.highlightedBgStyle];
    UIColor* shadowColor = [UIColor colorFromStyle:self.shadowColor];
    UIColor* selectedColor = [self getColorFromStyle:self.compoundStyleContainer.selectedBgStyle];
	
	//this gets called from layoutsubviews
	//colors might noth have been set yet.
	if(bgColor && highlightedBgColor)
	{
		// set background images
		
        UIImage *normalImage = [self getBackgroundImage:NO
                                                bgColor:bgColor
                                     highlightedBgColor:highlightedBgColor
                                            shadowColor:shadowColor
                                          progressColor:selectedColor];
        
        UIImage *highlightedImage = [self getBackgroundImage:YES
                                                     bgColor:bgColor
                                          highlightedBgColor:highlightedBgColor
                                                 shadowColor:shadowColor
                                               progressColor:selectedColor];
    
		self.lastDrawnSize = self.bounds.size;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setBackgroundImage:normalImage forState:UIControlStateNormal];
            [self setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
        });
	}
}

- (UIImage *)getBackgroundImage:(BOOL)selected
						bgColor:(UIColor *)bgColor
			 highlightedBgColor:(UIColor *)highlightedBgColor
					 shadowColor:(UIColor *)shadowColor
					 progressColor:(UIColor *)progressColor
{
	UIImage *result = selected ? self.highlightedStateImage : self.normalStateImage;
	
	if (!result)
	{
		CGSize size = self.bounds.size;
		CGFloat scale = [[UIScreen mainScreen] scale];
		CGRect rect = CGRectMake(0, 0, size.width, size.height);
		
		CGRect progressRect = rect;
		progressRect.size.width = round(self.transitionalProgress * size.width);
		
		CGRect remainingRect = rect;
		remainingRect.size.width = size.width - progressRect.size.width ;
		remainingRect.origin.x = progressRect.size.width;
		
        progressColor = progressColor?:highlightedBgColor;
		UIColor* remainingColor = bgColor;
		UIColor* progressSelected = progressColor;
		UIColor* remainingSelected = highlightedBgColor;
		
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
			
			UIColor* progressShadow = shadowColor;
			UIColor* remainingShadow = shadowColor;
			
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
			self.highlightedStateImage = image;
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

#pragma mark - custom animation

-(void)setupDisplayLink
{
    if(!self.displayLink)
    {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgressAnimation:)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }
}

-(void)updateProgressAnimation:(CADisplayLink*)displayLink
{
    if(self.startTime == 0)
    {
        self.startTime = displayLink.timestamp;
    }
    
    CFTimeInterval time = displayLink.timestamp - self.startTime;
    
    if(time>animationDuration)
    {
        //Tear down display link and thread
        self.transitionalProgress = self.progress;
        [self resetBackgroundImages];
        [self setBackgroundImages];
        [displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.displayLink = nil;
        [self.animationThread cancel];
        self.animationThread = nil;
        self.startTime = 0;
        return;
    }
    
    CFTimeInterval normalisedTime = time / (animationDuration/2);
    
    
    //Quadratic ease in/out http://gizma.com/easing/
    if(normalisedTime < 1 )
    {
        self.transitionalProgress = self.progressStartPoint + (self.progress - self.progressStartPoint)/2*normalisedTime*normalisedTime ;
    }
    else
    {
        normalisedTime--;
        self.transitionalProgress = self.progressStartPoint + (-(self.progress - self.progressStartPoint)/2 * (normalisedTime*(normalisedTime-2) - 1));
    }
    
    //Drawing and setting images seems efficient enough. Want to avoid custom class since this baseclass is used everywhere.
    [self resetBackgroundImages];
    [self setBackgroundImages];
    
}


@end
