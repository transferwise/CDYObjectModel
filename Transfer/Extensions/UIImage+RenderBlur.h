//
//  UIImage+RenderBlur.h
//  Transfer
//
//  Created by Mats Trovik on 23/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RenderBlur)

+(void)blurImageInBackground:(UIImage*)inputImage withRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor withCompletionBlock:(void(^)(UIImage*))completionBlock;

+ (UIImage *)blurredImage:(UIImage*)inputImage withRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

@end
