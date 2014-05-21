//
//  MOMCompoundStyle
//
//  Created by Mats Trovik on 15/11/2013.
//  Copyright (c) 2014 Matsomatic Limited All rights reserved.
//

#import "MOMStyle.h"

@interface MOMCompoundStyle : MOMStyle

@property (nonatomic, strong) MOMStyle *bgStyle;
@property (nonatomic, strong) MOMStyle *fontStyle;
@property (nonatomic, strong) MOMStyle *selectedBgStyle;
@property (nonatomic, strong) MOMStyle *selectedFontStyle;
@property (nonatomic, strong) MOMStyle *highlightedBgStyle;
@property (nonatomic, strong) MOMStyle *highlightedFontStyle;
@property (nonatomic, strong) MOMStyle *appearanceStyle;

/**
 *  apply this compound style to a view
 *
 *  styles for fonts and colors are applied for normal, selected and highlighted states if defined.
 *
 *  @param targetView view to style
 */
-(void)applyStyleToView:(UIView *)targetView;

@end
