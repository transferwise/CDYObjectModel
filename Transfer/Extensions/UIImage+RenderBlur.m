//
//  UIImage+RenderBlur.m
//  Transfer
//
//  Created by Mats Trovik on 23/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "UIImage+RenderBlur.h"
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (RenderBlur)

+ (UIImage *)blurredImage:(UIImage*)inputImage withRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor
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

+(void)blurImageInBackground:(UIImage*)inputImage withRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor withCompletionBlock:(void(^)(UIImage*))completionBlock
{
    if(!completionBlock)
    {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Blur
        UIImage *result = [self blurredImage:inputImage withRadius:radius iterations:iterations tintColor:tintColor];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(result);
        });
    });
    
}



+(void)headerBackgroundFromImage:(UIImage*)source finalImageSize:(CGSize)wantedSize completionBlock:(void(^)(UIImage* result))completionBlock
{
    if(!completionBlock)
    {
        return;
    }
    
    CGSize blurSize = source.size;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    //Crop blurred image
    NSUInteger scale = source.scale;
    CGRect rect = CGRectMake(blurSize.height/500.0f *(60.0f)*scale,
                             blurSize.height/500.0f *(20.0f)*scale,
                             blurSize.height/500.0f *wantedSize.width *scale,
                             blurSize.height/500.0f * wantedSize.height *scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([source CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef
                                           scale:scale
                                     orientation:source.imageOrientation];
    CGImageRelease(imageRef);
    
    //Scale it up
    
    UIGraphicsBeginImageContextWithOptions(wantedSize, NO, 0.0);
    [cropped drawInRect:CGRectMake(0, 0, wantedSize.width, wantedSize.height)];
    UIImage *scaledup = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    //Blur
    [UIImage blurImageInBackground:scaledup withRadius:80 iterations:8 tintColor:nil withCompletionBlock:^(UIImage *result) {
        completionBlock(result);
    }];
    
});
    
}



@end
