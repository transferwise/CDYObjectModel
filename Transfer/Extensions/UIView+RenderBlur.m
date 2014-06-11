//
//  UIView+RenderBlur.m
//  DigitalEdition
//
//  Created by Mats Trovik on 12/02/2014.
//  Copyright (c) 2014 Matsomatic Limited. All rights reserved.
//

#import "UIView+RenderBlur.h"

#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>

#define kScaleDownFactor 2

@implementation UIView (RenderBlur)

-(UIImage*)renderBlurWithTintColor:(UIColor*)tint
{
    //Create lower resolution image to make blurring faster
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
    
    //Blur
    result = [self blurredImage:result withRadius:10.0f iterations:4 tintColor:tint];
    
    //Scale back to original size
    CGSize newSize = CGSizeMake(self.bounds.size.width,self.bounds.size.height);
    UIGraphicsBeginImageContextWithOptions(newSize,YES, 0.0);
    [result drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

- (UIImage *)blurredImage:(UIImage*)inputImage withRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor
{
    /*
     Based on
    https://github.com/nicklockwood/FXBlurView
    */
    
    //image must be nonzero size
    if (floorf(inputImage.size.width) * floorf(inputImage.size.height) <= 0.0f) return inputImage;
    
    //boxsize must be an odd integer
    uint32_t boxSize = (uint32_t)(radius * inputImage.scale);
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    CGImageRef imageRef = inputImage.CGImage;
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    size_t bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < iterations; i++)
    {
        //perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }
    
    //free buffers
    free(buffer2.data);
    free(tempBuffer);
    
    //create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
    {
        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }
    
    //create image from context
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:inputImage.scale orientation:inputImage.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    return image;
}

@end
