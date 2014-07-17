//
//  ProgressButton.m
//  Transfer
//
//  Created by Mats Trovik on 17/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ProgressButton.h"
#import "MOMStyle.h"
#import "Constants.h"

@interface ProgressButton ()
@property (nonatomic, assign) CGSize lastDrawnSize;
@end

@implementation ProgressButton

- (id)initWithFrame:(CGRect)frame {
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
    self.fontStyle = @"medium.@{17,19}.white";
    self.exclusiveTouch = YES;
    self.backgroundColor = [UIColor clearColor];
}

-(void)setProgress:(CGFloat)progress
{
    if(_progress != progress)
    {
        _progress = progress;
        [self redrawImages];
    }
}

-(void)layoutSubviews
{
    if(self.bounds.size.width != self.lastDrawnSize.width  || self.bounds.size.height != self.lastDrawnSize.height)
    {
        [self redrawImages];
    }
    [super layoutSubviews];
}

-(void)setAddShadow:(BOOL)addShadow
{
    _addShadow = addShadow;
    [self redrawImages];
}

-(void)redrawImages
{
    
    CGSize size = self.bounds.size;
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    CGRect progressRect = rect;
    progressRect.size.width = round(self.progress * size.width);
    
    CGRect remainingRect = rect;
    remainingRect.size.width = size.width - progressRect.size.width ;
    remainingRect.origin.x = progressRect.size.width;
    
    
    UIColor* progressColor = [UIColor colorFromStyle:@"GreenHighlighted"];
    UIColor* remainingColor = [UIColor colorFromStyle:@"green"];
    UIColor* progressSelected = [UIColor colorFromStyle:@"GreenHighlighted"];
    UIColor* remainingSelected = [UIColor colorFromStyle:@"GreenHighlighted"];
    
    UIGraphicsBeginImageContextWithOptions(size,YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [progressColor CGColor]);
    CGContextFillRect(context, progressRect);
    CGContextSetFillColorWithColor(context, [remainingColor CGColor]);
    CGContextFillRect(context, remainingRect);
    
    if(self.addShadow)
    {
        CGRect progressShadowRect = progressRect;
        progressShadowRect.origin.y = size.height - 4.0f;
        progressShadowRect.size.height = 4.0f;
        
        CGRect remainingShadowRect = remainingRect;
        remainingShadowRect.origin.y = size.height - 4.0f;
        remainingShadowRect.size.height = 4.0f;
        
        UIColor* progressShadow = [UIColor colorFromStyle:@"GreenShadow"];
        UIColor* remainingShadow = [UIColor colorFromStyle:@"GreenShadow"];
        
        CGContextSetFillColorWithColor(context, [progressShadow CGColor]);
        CGContextFillRect(context, progressShadowRect);
        CGContextSetFillColorWithColor(context, [remainingShadow CGColor]);
        CGContextFillRect(context, remainingShadowRect);
    }
    
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage* normal = [UIImage imageWithCGImage:cgImage scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    [self setBackgroundImage:normal forState:UIControlStateNormal];
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(size,NO, 0.0);
    context = UIGraphicsGetCurrentContext();
    
    if(self.addShadow)
    {
        progressRect.origin.y += 2.0f;
        CGContextSetFillColorWithColor(context, [progressSelected CGColor]);
        CGContextFillRect(context, progressRect);
        
        remainingRect.origin.y += 2.0f;
        CGContextSetFillColorWithColor(context, [remainingSelected CGColor]);
        CGContextFillRect(context, remainingRect);
        
        CGRect progressShadowRect = progressRect;
        progressShadowRect.origin.y = size.height - 2.0f;
        progressShadowRect.size.height = 2.0f;
        
        CGRect remainingShadowRect = remainingRect;
        remainingShadowRect.origin.y = size.height - 2.0f;
        remainingShadowRect.size.height = 2.0f;
        
        CGRect alphaRect = rect;
        alphaRect.origin.y =0.0f;
        alphaRect.size.height = 2.0f;
        
        UIColor* progressShadow = [UIColor colorFromStyle:@"GreenShadow"];
        UIColor* remainingShadow = [UIColor colorFromStyle:@"GreenShadow"];
        
        CGContextSetFillColorWithColor(context, [progressShadow CGColor]);
        CGContextFillRect(context, progressShadowRect);
        CGContextSetFillColorWithColor(context, [remainingShadow CGColor]);
        CGContextFillRect(context, remainingShadowRect);
        CGContextBeginTransparencyLayer(context, NULL);
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        CGContextFillRect(context, alphaRect);
        CGContextEndTransparencyLayer(context);
    }
    else
    {
        CGContextSetFillColorWithColor(context, [progressSelected CGColor]);
        CGContextFillRect(context, progressRect);
        CGContextSetFillColorWithColor(context, [remainingSelected CGColor]);
        CGContextFillRect(context, remainingRect);
    }
    
    cgImage = CGBitmapContextCreateImage(context);
    UIImage* highlight = [UIImage imageWithCGImage:cgImage scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    [self setBackgroundImage:highlight forState:UIControlStateHighlighted];
    UIGraphicsEndImageContext();
    
    
    self.lastDrawnSize = self.bounds.size;
    
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if(IPAD)
    {
        if(highlighted)
        {
            self.contentEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0);
        }
        else
        {
            self.contentEdgeInsets = UIEdgeInsetsZero;
        }
    }
}


@end
