//
//  UIColor+SinglePixelImage.h
//
//  Created by Mats Trovik on 15/11/2013.
//  Copyright (c) 2014 Matsomatic Limited All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SinglePixelImage)
/**
 *  Create single pixel size image with this UIColor's color.
 *
 *  @return single pixel size image with this UIColor's color.
 */
-(UIImage*)singlePixelImage;

/**
 *  Create an image filled with this UIColor's color.
 *
 *  @param size required image size
 *
 *  @return mage filled with this UIColor's color of the specified size.
 */
-(UIImage*)imageWithSize:(CGSize)size;
@end
