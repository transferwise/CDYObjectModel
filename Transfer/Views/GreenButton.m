//
//  GreenButton.m
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "GreenButton.h"
#import "UIButton+Skinning.h"
#import "MOMStyle.h"
#import "Constants.h"

@implementation GreenButton

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
    self.compoundStyle = @"greenButton";
    self.exclusiveTouch = YES;
    
    if(self.addShadow)
    {
        [self setBackgroundImage:[self normalStateImage] forState:UIControlStateNormal];
        [self setBackgroundImage:[self selectedStateImage] forState:UIControlStateHighlighted];
        
    }
}

-(void)setAddShadow:(BOOL)addShadow
{
    _addShadow = addShadow;
    
    if(self.addShadow)
    {
        // set background images
        [self setBackgroundImage:[self normalStateImage] forState:UIControlStateNormal];
        [self setBackgroundImage:[self selectedStateImage] forState:UIControlStateHighlighted];
        
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

static __weak UIImage* normalStateImage;
-(UIImage*)normalStateImage
{
    UIImage *result = normalStateImage;
    if (!result)
    {
        
        CGFloat scale = [[UIScreen mainScreen] scale];
        CGSize size = CGSizeMake(3.0f, 8.0f);
        
        CGRect mainRect = CGRectMake(0.0f, 0.0f, 3.0f, 4.0f);
        
        
        CGRect shadowRect = CGRectMake(0.0f, 4.0f, 3.0f, 4.0f);
        
        
        UIColor* greenColor = [UIColor colorFromStyle:@"green"];
        UIColor* GreenShadow = [UIColor colorFromStyle:@"GreenShadow"];
        
        UIGraphicsBeginImageContextWithOptions(size,YES, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [greenColor CGColor]);
        CGContextFillRect(context, mainRect);
        CGContextSetFillColorWithColor(context, [GreenShadow CGColor]);
        CGContextFillRect(context, shadowRect);
        
        CGImageRef cgImage = CGBitmapContextCreateImage(context);
        UIImage* image = [UIImage imageWithCGImage:cgImage scale:scale orientation:UIImageOrientationUp];
        CGImageRelease(cgImage);
                UIGraphicsEndImageContext();
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(3, 1, 4, 1)];
        result = image;
        normalStateImage = image;
    }
    
    return result;
}

static __weak UIImage* selectedStateImage;
-(UIImage*)selectedStateImage
{
    UIImage *result = selectedStateImage;
    if (!result)
    {
        
        CGFloat scale = [[UIScreen mainScreen] scale];
        CGSize size = CGSizeMake(3.0f, 8.0f);
        
        CGRect mainRect = CGRectMake(0.0f, 2.0f, 3.0f, 4.0f);
        
        
        CGRect shadowRect = CGRectMake(0.0f, 6.0f, 3.0f, 2.0f);
        
        
        UIColor* greenColor = [UIColor colorFromStyle:@"GreenHighlighted"];
        UIColor* GreenShadow = [UIColor colorFromStyle:@"GreenShadow"];
        
        UIGraphicsBeginImageContextWithOptions(size,NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [greenColor CGColor]);
        CGContextFillRect(context, mainRect);
        CGContextSetFillColorWithColor(context, [GreenShadow CGColor]);
        CGContextFillRect(context, shadowRect);
        
        CGImageRef cgImage = CGBitmapContextCreateImage(context);
        UIImage* image = [UIImage imageWithCGImage:cgImage scale:scale orientation:UIImageOrientationUp];
        CGImageRelease(cgImage);
        UIGraphicsEndImageContext();

        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(3, 1, 4, 1)];
        result = image;
        selectedStateImage = image;
    }
    
    return result;
}


@end
