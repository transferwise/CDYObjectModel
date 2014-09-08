//
//  UIColor+SinglePixelImage.h
//
//  Created by Mats Trovik on 15/11/2013.
//  Copyright (c) 2014 Matsomatic Limited All rights reserved.
//

#import "UIColor+SinglePixelImage.h"

@implementation UIColor (SinglePixelImage)

-(UIImage*)singlePixelImage
{
    return [self imageWithSize:CGSizeMake(1, 1)];
}

-(UIImage*)imageWithSize:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
