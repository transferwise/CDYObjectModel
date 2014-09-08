//
//  MOMCompoundStyle
//
//  Created by Mats Trovik on 15/11/2013.
//  Copyright (c) 2014 Matsomatic Limited All rights reserved.
//

#import "MOMCompoundStyle.h"
#import "UIView+MOMStyle.h"

@implementation MOMCompoundStyle

-(instancetype)copyWithZone:(NSZone *)zone
{
    
    MOMCompoundStyle* copy = [super copyWithZone:zone];
    
    copy.bgStyle = [_bgStyle copy];
    copy.fontStyle = [_fontStyle copy];
    copy.selectedBgStyle = [_selectedBgStyle copy];
    copy.selectedFontStyle = [_selectedFontStyle copy];
    copy.highlightedBgStyle = [_highlightedBgStyle copy];
    copy.highlightedFontStyle = [_highlightedFontStyle copy];
    
    return copy;
}

-(void)applyStyleToView:(UIView *)targetView{
    if(!targetView.bgStyle)
    {
        [self.bgStyle applyColorStyleToView:targetView forControlState:UIControlStateNormal];
    }
    if(!targetView.fontStyle)
    {
        [self.fontStyle applyFontStyleToView:targetView forControlState:UIControlStateNormal];
    }
    if(!targetView.selectedBgStyle)
    {
        [self.selectedBgStyle applyColorStyleToView:targetView forControlState:UIControlStateSelected];
    }
    if(!targetView.selectedFontStyle)
    {
        [self.selectedFontStyle applyFontStyleToView:targetView forControlState:UIControlStateSelected];
    }
    if(!targetView.highlightedBgStyle)
    {
        [self.highlightedBgStyle applyColorStyleToView:targetView forControlState:UIControlStateHighlighted];
    }
    if(!targetView.highlightedFontStyle)
    {
        [self.highlightedFontStyle applyFontStyleToView:targetView forControlState:UIControlStateHighlighted];
    }
    
    [self.appearanceStyle applyAppearanceStyleToView:targetView];
}

@end
