//
//  UIView+MOMStyle
//
//  Created by Mats Trovik on 15/11/2013.
//  Copyright (c) 2014 Matsomatic Limited All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UIView (MOMStyle)

@property (nonatomic, strong) IBInspectable NSString* bgStyle;
@property (nonatomic, strong) IBInspectable NSString* fontStyle;
@property (nonatomic, strong) IBInspectable NSString* selectedBgStyle;
@property (nonatomic, strong) IBInspectable NSString* selectedFontStyle;
@property (nonatomic, strong) IBInspectable NSString* highlightedBgStyle;
@property (nonatomic, strong) IBInspectable NSString* highlightedFontStyle;
@property (nonatomic, strong) IBInspectable NSString* compoundStyle;
@property (nonatomic, strong) IBInspectable NSString* appearanceStyle;

-(void)recursivelyReapplyStyles;

@end
