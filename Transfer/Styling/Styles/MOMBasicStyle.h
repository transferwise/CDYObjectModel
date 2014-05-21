//
//  MOMBasicStyle.h
//  StyleTest
//
//  Created by Mats Trovik on 27/03/2014.
//  Copyright (c) 2014 Matsomatic. All rights reserved.
//

#import "MOMBaseStyle.h"

@interface MOMBasicStyle : MOMBaseStyle

@property (nonatomic,copy) NSNumber* red; //< 0.0-1.0f value for red color
@property (nonatomic,copy) NSNumber* green; //< 0.0-1.0f value for green color
@property (nonatomic,copy) NSNumber* blue; //< 0.0-1.0f value for blue color
@property (nonatomic,copy) NSNumber* alpha; //< 0.0-1.0f value for alpha color


@property (nonatomic, copy) NSString* fontName;
@property (nonatomic, copy) NSNumber* fontSize;

@property (nonatomic,copy) NSNumber* shadowRed; //< 0.0-1.0f value for red color
@property (nonatomic,copy) NSNumber* shadowGreen; //< 0.0-1.0f value for green color
@property (nonatomic,copy) NSNumber* shadowBlue; //< 0.0-1.0f value for blue color
@property (nonatomic,copy) NSNumber* shadowAlpha; //< 0.0-1.0f value for alpha color
@property (nonatomic,copy)NSNumber* shadowOffsetX;
@property (nonatomic,copy)NSNumber* shadowOffsetY;

-(UIFont*)font;
-(UIColor *)shadowColor;
-(CGSize)shadowOffset;

/**
 Convenience method for setting shadow color with hex string values.
 
 @param hexString RGB or RGBA value expressed as 2 hex digits/color (00 - FF) . Ex @"FF0000" (red) or "00FF0055" (blue with transparency).
 */
-(void)setShadowColorWithHexString:(NSString*)hexString;

/**
 Convenience method for setting color with hex string values.
 
 @param hexString RGB or RGBA value expressed as 2 hex digits/color (00 - FF) . Ex @"FF0000" (red) or "00FF0055" (blue with transparency).
 */
-(void)setColorWithHexString:(NSString*)hexString;

-(UIColor *)color;


@end
