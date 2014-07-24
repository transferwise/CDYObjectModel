//
//  UIView+RenderBlur.m
//  DigitalEdition
//
//  Created by Mats Trovik on 12/02/2014.
//  Copyright (c) 2014 Matsomatic Limited. All rights reserved.
//

#import "UIView+RenderBlur.h"
#import "UIImage+RenderBlur.h"

#define kScaleDownFactor 2

@implementation UIView (RenderBlur)

-(void)blurInBackgroundWithCompletionBlock:(void(^)(UIImage*))completionBlock
{
    if(!completionBlock)
    {
        return;
    }
    
    __block UIImage* result = [self grabSnapshotOfSelf];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Blur
        result = [UIImage blurredImage:result withRadius:6.0f iterations:4 tintColor:nil];
        
        //Scale back to original size
        CGSize newSize = CGSizeMake(self.bounds.size.width,self.bounds.size.height);
        UIGraphicsBeginImageContextWithOptions(newSize,YES, 0.0);
        [result drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(result);
        });
    
    });
}

-(UIImage*)renderBlurWithTintColor:(UIColor*)tint
{
    //Create lower resolution image to make blurring faster
    
    UIImage *result = [self grabSnapshotOfSelf];
    
    //Blur
    result = [UIImage blurredImage:result withRadius:6.0f iterations:4 tintColor:tint];
    
    //Scale back to original size
    CGSize newSize = CGSizeMake(self.bounds.size.width,self.bounds.size.height);
    UIGraphicsBeginImageContextWithOptions(newSize,YES, 0.0);
    [result drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

-(UIImage*)grabSnapshotOfSelf
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.bounds.size.width/kScaleDownFactor,self.bounds.size.height/kScaleDownFactor), YES, 0.0);
    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
    {
        [self drawViewHierarchyInRect:CGRectMake(0,0,self.bounds.size.width/kScaleDownFactor, self.bounds.size.height/kScaleDownFactor) afterScreenUpdates:YES];
    }
    else
    {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;

}

@end
