//
//  MOMStyle
//
//  Created by Mats Trovik on 15/11/2013.
//  Copyright (c) 2014 Matsomatic Limited All rights reserved.
//

#import<UIKit/UIKit.h>

/**
 Base class for styles applied to UIViews. Styles can be chained by being added through the @addStyle method.
 */
@interface MOMStyle : NSObject <NSCopying>

@property (nonatomic,readonly) MOMStyle *compositeStyle;

@property (nonatomic,readonly) MOMStyle *child;

/**
 *  apply a color style to a view. Specific implementation should be written in child class.
 *
 *  @param targetView   view to apply style to.
 *  @param controlState control state for which to apply the style
 */
-(void)applyColorStyleToView:(UIView *)targetView forControlState:(UIControlState)controlState;

/**
 *  apply a font style to a view. Specific implementation to be written in child class.
 *
 *  @param targetView   view to apply style to.
 *  @param controlState control state for which to apply the style
 */
-(void)applyFontStyleToView:(UIView *)targetView forControlState:(UIControlState)controlState;

/**
 *  apply appearnace block to view
 *
 *  @param targetView view to apply appearance block to.
 */
-(void)applyAppearanceStyleToView:(UIView *)targetView;

/**
 *  Add a sub-style to this style. properties defined on a child style will override the parent.
 *
 *  As an example a color style only defining an alpha value can be added to another color style to make it semi transparent.
 *
 *  @param style Style to add
 */
-(void)addStyle:(MOMStyle*)style;


/**
 *  Returns a new style object wrapping this style in its read-only composite property.
 *
 *  @return initialised style with this as its composite style
 */
-(instancetype)styleWrappedAsComposite;

/**
 *  initialisation method which sets the read-only composite style. All properties are read from the composite unless overriden by a child.
 *
 *  used to avoid copying base styles.
 *
 *  @param compositeStyle style to wrap
 *
 *  @return initialised style with a composite style.
 */
-(instancetype)initWithCompositeStyle:(MOMStyle*)compositeStyle;


@end


typedef void (^ApplyAppearanceBlock)(UIView*);

@interface MOMAppearanceStyle : MOMStyle

-(ApplyAppearanceBlock)apperanceBlock;

@end