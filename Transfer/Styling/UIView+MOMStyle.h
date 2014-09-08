//
//  UIView+MOMStyle
//
//  Created by Mats Trovik on 15/11/2013.
//  Copyright (c) 2014 Matsomatic Limited All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MOMStyle)

@property (nonatomic, strong) NSString* bgStyle;
@property (nonatomic, strong) NSString* fontStyle;
@property (nonatomic, strong) NSString* selectedBgStyle;
@property (nonatomic, strong) NSString* selectedFontStyle;
@property (nonatomic, strong) NSString* highlightedBgStyle;
@property (nonatomic, strong) NSString* highlightedFontStyle;
@property (nonatomic, strong) NSString* compoundStyle;
@property (nonatomic, strong) NSString* appearanceStyle;

-(void)recursivelyReapplyStyles;

@end
