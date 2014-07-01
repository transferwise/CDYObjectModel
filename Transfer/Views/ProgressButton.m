//
//  ProgressButton.m
//  Transfer
//
//  Created by Mats Trovik on 17/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ProgressButton.h"
#import "MOMStyle.h"

@interface ProgressButton ()
@property (nonatomic,assign)CGSize lastDrawnSize;
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
    self.fontStyle = @"H4";
    self.exclusiveTouch = YES;
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

-(void)redrawImages
{
    UIColor* progressColor = [UIColor colorFromStyle:@"darkGreen"];
    UIColor* remainingColor = [UIColor colorFromStyle:@"green"];
    UIColor* progressColorHighlight = [UIColor colorFromStyle:@"darkGreen.alpha2"];
    UIColor* remainingColorHighlight = [UIColor colorFromStyle:@"green.alpha2"];
    
    
    CGSize size = self.bounds.size;
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGRect rect = CGRectMake(0, 0, size.width * scale, size.height * scale);

    CGRect progressRect = rect;
    progressRect.size.width = round(self.progress * size.width * scale );
    
    CGRect remainingRect = rect;
    remainingRect.size.width = size.width * scale - progressRect.size.width ;
    remainingRect.origin.x = progressRect.size.width;

    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [progressColor CGColor]);
    CGContextFillRect(context, progressRect);
    CGContextSetFillColorWithColor(context, [remainingColor CGColor]);
    CGContextFillRect(context, remainingRect);
    UIImage* normal = UIGraphicsGetImageFromCurrentImageContext();
    [self setBackgroundImage:normal forState:UIControlStateNormal];
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(rect.size);
    context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [progressColorHighlight CGColor]);
    CGContextFillRect(context, progressRect);
    CGContextSetFillColorWithColor(context, [remainingColorHighlight CGColor]);
    CGContextFillRect(context, remainingRect);
    UIImage* highlight = UIGraphicsGetImageFromCurrentImageContext();
    [self setBackgroundImage:highlight forState:UIControlStateHighlighted];
    UIGraphicsEndImageContext();
    
    self.lastDrawnSize = size;
    
}

@end
