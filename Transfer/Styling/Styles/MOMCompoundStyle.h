//
//  MOMCompoundStyle
//
//  Created by Mats Trovik on 15/11/2013.
//  Copyright (c) 2014 Matsomatic Limited All rights reserved.
//

#import "MOMBaseStyle.h"

@interface MOMCompoundStyle : MOMBaseStyle

@property (nonatomic, strong) MOMBaseStyle *bgStyle;
@property (nonatomic, strong) MOMBaseStyle *fontStyle;
@property (nonatomic, strong) MOMBaseStyle *selectedBgStyle;
@property (nonatomic, strong) MOMBaseStyle *selectedFontStyle;
@property (nonatomic, strong) MOMBaseStyle *highlightedBgStyle;
@property (nonatomic, strong) MOMBaseStyle *highlightedFontStyle;
@property (nonatomic, strong) MOMBaseStyle *appearanceStyle;

/**
 *  apply this compound style to a view
 *
 *  styles for fonts and colors are applied for normal, selected and highlighted states if defined.
 *
 *  @param targetView view to style
 */
-(void)applyStyleToView:(UIView *)targetView;

@end
