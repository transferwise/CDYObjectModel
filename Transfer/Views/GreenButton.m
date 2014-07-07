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
        [self setBackgroundImage:[self normalImage] forState:UIControlStateNormal];
        [self setBackgroundImage:[self selectedimage] forState:UIControlStateHighlighted];
        
    }
}

-(void)setAddShadow:(BOOL)addShadow
{
    _addShadow = addShadow;
    
    if(self.addShadow)
    {
        // set background images
        [self setBackgroundImage:[self normalImage] forState:UIControlStateNormal];
        [self setBackgroundImage:[self selectedimage] forState:UIControlStateHighlighted];
        
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

static __weak UIImage* normalImage;
-(UIImage*)normalImage
{
    UIImage *result = normalImage;
    if (!result)
    {
        
        CGFloat scale = [[UIScreen mainScreen] scale];
        CGSize size = CGSizeMake(3.0f*scale, 8.0f*scale);
        
        CGRect mainRect = CGRectMake(0.0f, 0.0f, 3.0f*scale, 4.0f*scale);
        
        
        CGRect shadowRect = CGRectMake(0.0f, 4.0f * scale, 3.0f*scale, 4.0f*scale);
        
        
        UIColor* greenColor = [UIColor colorFromStyle:@"green"];
        UIColor* greenShadow = [UIColor colorFromStyle:@"greenShadow"];
        
        UIGraphicsBeginImageContextWithOptions(size,YES, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [greenColor CGColor]);
        CGContextFillRect(context, mainRect);
        CGContextSetFillColorWithColor(context, [greenShadow CGColor]);
        CGContextFillRect(context, shadowRect);
        
        UIImage* normal = UIGraphicsGetImageFromCurrentImageContext();
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(3, 1, 4, 1)];
        UIGraphicsEndImageContext();
        result = normal;
        normalImage = normal;
    }
    
    return result;
}

static __weak UIImage* selectedImage;
-(UIImage*)selectedimage
{
    UIImage *result = selectedImage;
    if (!result)
    {
        
        CGFloat scale = [[UIScreen mainScreen] scale];
        CGSize size = CGSizeMake(3.0f*scale, 8.0f*scale);
        
        CGRect mainRect = CGRectMake(0.0f, 2.0f*scale, 3.0f*scale, 2.0f*scale);
        
        
        CGRect shadowRect = CGRectMake(0.0f, 4.0f * scale, 3.0f*scale, 4.0f*scale);
        
        
        UIColor* greenColor = [UIColor colorFromStyle:@"greenSelected"];
        UIColor* greenShadow = [UIColor colorFromStyle:@"greenShadow"];
        
        UIGraphicsBeginImageContextWithOptions(size,NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [greenColor CGColor]);
        CGContextFillRect(context, mainRect);
        CGContextSetFillColorWithColor(context, [greenShadow CGColor]);
        CGContextFillRect(context, shadowRect);
        
        UIImage* normal = UIGraphicsGetImageFromCurrentImageContext();
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(3, 1, 4, 1)];
        UIGraphicsEndImageContext();
        result = normal;
        selectedImage = normal;
    }
    
    return result;
}


@end
