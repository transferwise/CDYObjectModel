//
//  UIView+MOMStyle
//
//  Created by Mats Trovik on 15/11/2013.
//  Copyright (c) 2014 Matsomatic Limited All rights reserved.
//

#import "UIView+MOMStyle.h"
#import <objc/runtime.h>
#import "MOMStyleFactory.h"
#import "MOMCompoundStyle.h"

@implementation UIView (MOMStyle)

#pragma mark - background color

-(NSString*)bgStyle
{
    return objc_getAssociatedObject(self, @selector(bgStyle));
}

-(void)setBgStyle:(NSString *)backgroundStyle
{
    [self setColorStyle:backgroundStyle forIdentifier:@selector(bgStyle) forControlState:UIControlStateNormal];
}

-(NSString*)selectedBgStyle
{
    return objc_getAssociatedObject(self, @selector(selectedBgStyle));
}

-(void)setSelectedBgStyle:(NSString *)backgroundStyle
{
    [self setColorStyle:backgroundStyle forIdentifier:@selector(selectedBgStyle) forControlState:UIControlStateSelected];
}

-(NSString*)highlightedBgStyle
{
    return objc_getAssociatedObject(self, @selector(highlightedBgStyle));
}

-(void)setHighlightedBgStyle:(NSString *)backgroundStyle
{
    [self setColorStyle:backgroundStyle forIdentifier:@selector(highlightedBgStyle) forControlState:UIControlStateHighlighted];
}


#pragma mark - fonts

-(NSString*)fontStyle
{
    return objc_getAssociatedObject(self, @selector(fontStyle));
}

-(void)setFontStyle:(NSString *)fontStyle
{
    [self setFontStyle:fontStyle forIdentifier:@selector(fontStyle) forControlState:UIControlStateNormal];
}

-(NSString*)selectedFontStyle
{
    return objc_getAssociatedObject(self, @selector(selectedFontStyle));
}

-(void)setSelectedFontStyle:(NSString *)fontStyle
{
    [self setFontStyle:fontStyle forIdentifier:@selector(selectedFontStyle) forControlState:UIControlStateSelected];
}

-(NSString*)highlightedFontStyle
{
    return objc_getAssociatedObject(self, @selector(highlightedFontStyle));
}

-(void)setHighlightedFontStyle:(NSString *)fontStyle
{
    [self setFontStyle:fontStyle forIdentifier:@selector(highlightedFontStyle) forControlState:UIControlStateHighlighted];
}

#pragma mark - other styles

-(NSString*)compoundStyle
{
    return objc_getAssociatedObject(self, @selector(compoundStyle));
}

-(void)setCompoundStyle:(NSString *)compoundStyle
{
    objc_setAssociatedObject(self, @selector(compoundStyle), compoundStyle ,OBJC_ASSOCIATION_COPY);
    MOMCompoundStyle* style = [MOMStyleFactory compoundStyleForIdentifier:compoundStyle];
    [style applyStyleToView:self];
}

-(NSString*)appearanceStyle
{
    return objc_getAssociatedObject(self, @selector(appearanceStyle));
}

-(void)setAppearanceStyle:(NSString *)compoundStyle
{
    objc_setAssociatedObject(self, @selector(appearanceStyle), compoundStyle ,OBJC_ASSOCIATION_COPY);
    MOMStyle* style = [MOMStyleFactory getStyleForIdentifier:compoundStyle];
    [style applyAppearanceStyleToView:self];
}

#pragma mark - convenience method

-(void)setColorStyle:(NSString*)styleName forIdentifier:(SEL)identifier forControlState:(UIControlState)state
{
    objc_setAssociatedObject(self, identifier, styleName,OBJC_ASSOCIATION_COPY);
    MOMStyle* result = [MOMStyleFactory getStyleForIdentifier:styleName];
    [result applyColorStyleToView:self forControlState:state];
}

-(void)setFontStyle:(NSString*)styleName forIdentifier:(SEL)identifier forControlState:(UIControlState)state
{
    objc_setAssociatedObject(self, identifier, styleName,OBJC_ASSOCIATION_COPY);
    MOMStyle* result = [MOMStyleFactory getStyleForIdentifier:styleName];
    [result applyFontStyleToView:self forControlState:state];
}

-(void)recursivelyReapplyStyles
{
    [self reapplyStyles];
    for (UIView* child in self.subviews)
    {
        [child recursivelyReapplyStyles];
    }
}

-(void)reapplyStyles
{
    self.bgStyle = self.bgStyle;
    self.fontStyle = self.fontStyle;
    self.selectedBgStyle = self.selectedBgStyle;
    self.selectedFontStyle = self.selectedFontStyle;
    self.highlightedBgStyle = self.highlightedBgStyle;
    self.highlightedFontStyle = self.highlightedFontStyle;
    self.appearanceStyle = self.appearanceStyle;
    self.compoundStyle = self.compoundStyle;
}

@end
