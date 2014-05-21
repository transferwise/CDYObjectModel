//
//  MOMBasicStyle.m
//  StyleTest
//
//  Created by Mats Trovik on 27/03/2014.
//  Copyright (c) 2014 Matsomatic. All rights reserved.
//

#import "MOMBasicStyle.h"
#import "NSString+MOMStyle.h"
#import "UIColor+SinglePixelImage.h"

@implementation MOMBasicStyle

-(instancetype)copyWithZone:(NSZone *)zone
{
    MOMBasicStyle* copy = [super copyWithZone:zone];
    copy.red = [_red copy];
    copy.blue = [_blue copy];
    copy.green = [_green copy];
    copy.alpha = [_alpha copy];
    
    copy.fontName = _fontName;
    copy.fontSize = _fontSize;
    
    copy.shadowAlpha = _shadowAlpha;
    copy.shadowBlue = _shadowBlue;
    copy.shadowGreen = _shadowGreen;
    copy.shadowRed = _shadowRed;
    copy.shadowOffsetX = _shadowOffsetX;
    copy.shadowOffsetY = _shadowOffsetY;
    
    return copy;
}

-(void)setColorWithHexString:(NSString*)hexString
{
    [hexString mapHexToRedNumber:&_red greenNumber:&_green blueNumber:&_blue alphaNumber:&_alpha];
}

-(MOMBasicStyle*)getChildBasicStyle
{
    MOMStyle *child = self.child;
    while (child)
    {
        if ([child isKindOfClass:[MOMBasicStyle class]])
        {
            return (MOMBasicStyle*)child;
        }
        child = child.child;
    }
    return nil;
}

-(NSNumber *)red
{
    return [self getChildBasicStyle].red?:((MOMBasicStyle*)self.compositeStyle).red?:_red;
}

-(NSNumber *)green
{
    return [self getChildBasicStyle].green?:((MOMBasicStyle*)self.compositeStyle).green?:_green;
}

-(NSNumber *)blue
{
    return [self getChildBasicStyle].blue?:((MOMBasicStyle*)self.compositeStyle).blue?:_blue;
}

-(NSNumber *)alpha
{
    return [self getChildBasicStyle].alpha?:((MOMBasicStyle*)self.compositeStyle).alpha?:_alpha;
}

-(UIColor *)color
{
    if(!self.red || !self.green || !self.blue)
    {
        return nil;
    }
    NSNumber* alpha = [self alpha]?:@(1.0f);
    return [UIColor colorWithRed:[self.red floatValue] green:[self.green floatValue] blue:[self.blue floatValue] alpha:[alpha floatValue]];
}


-(NSString *)fontName
{
    return [self getChildBasicStyle].fontName?:((MOMBasicStyle*)self.compositeStyle).fontName?:_fontName;
}

-(NSNumber *)fontSize
{
    return [self getChildBasicStyle].fontSize?:((MOMBasicStyle*)self.compositeStyle).fontSize?:_fontSize;
}

-(UIFont *)font
{
    NSString* fontName = self.fontName;
    NSNumber* fontSize = self.fontSize;
    if(fontName && fontSize)
    {
        return [UIFont fontWithName:fontName size:[fontSize floatValue]];
    }
    return nil;
    
}

-(NSNumber *)shadowRed
{
    return [self getChildBasicStyle].shadowRed?:((MOMBasicStyle*)self.compositeStyle).shadowRed?:_shadowRed;
}

-(NSNumber *)shadowGreen
{
    return [self getChildBasicStyle].shadowGreen?:((MOMBasicStyle*)self.compositeStyle).shadowGreen?:_shadowGreen;
}

-(NSNumber *)shadowBlue
{
    return [self getChildBasicStyle].shadowBlue?:((MOMBasicStyle*)self.compositeStyle).shadowBlue?:_shadowBlue;
}

-(NSNumber *)shadowAlpha
{
    return [self getChildBasicStyle].shadowAlpha?:((MOMBasicStyle*)self.compositeStyle).shadowAlpha?:_shadowAlpha;
}

-(void)setShadowColorWithHexString:(NSString*)hexString
{
    [hexString mapHexToRedNumber:&_shadowRed greenNumber:&_shadowGreen blueNumber:&_shadowBlue alphaNumber:&_shadowAlpha];
}

-(NSNumber *)shadowOffsetX
{
    return [self getChildBasicStyle].shadowOffsetX?:((MOMBasicStyle*)self.compositeStyle).shadowOffsetX?:_shadowOffsetX;
}

-(NSNumber *)shadowOffsetY
{
    return [self getChildBasicStyle].shadowOffsetY?:((MOMBasicStyle*)self.compositeStyle).shadowOffsetY?:_shadowOffsetY;
}

-(UIColor *)shadowColor
{
    if(!self.shadowRed || !self.shadowGreen || !self.shadowBlue)
    {
        return nil;
    }
    NSNumber* alpha = [self shadowAlpha]?:@(1.0f);
    return [UIColor colorWithRed:[self.shadowRed floatValue] green:[self.shadowGreen floatValue] blue:[self.shadowBlue floatValue] alpha:[alpha floatValue]];
}

-(CGSize)shadowOffset
{
    return CGSizeMake([self.shadowOffsetX floatValue], [self.shadowOffsetY floatValue]);
}

-(void)applyColorStyleToView:(UIView *)targetView forControlState:(UIControlState)controlState{
    
    if([targetView isKindOfClass:[UIButton class]])
    {
        UIButton* button = (UIButton*) targetView;
        
        UIColor* color = self.color;
        if(color)
        {
            [button setBackgroundImage:[color singlePixelImage] forState:controlState];
        }
    }
    else if(controlState == UIControlStateNormal)
    {
        targetView.backgroundColor = [self color];
    }
    
}

-(void)applyFontStyleToView:(UIView *)targetView forControlState:(UIControlState)controlState{
    
    UIFont* font = self.font;
    
    if([targetView isKindOfClass:[UIButton class]])
    {
        UIButton* button = (UIButton*) targetView;
        if(font)
            [button.titleLabel setFont:font];
        
        UIColor* color = self.color;
        if(color)
        {
            [button setTitleColor:self.color forState:controlState];
        }
        if([self shadowColor])
        {
            [button setTitleShadowColor:[self shadowColor] forState:controlState];
            if (self.shadowOffsetY || self.shadowOffsetX)
            {
                button.titleLabel.shadowOffset = [self shadowOffset];
            }
        }
    }
    else if(controlState == UIControlStateNormal)
    {
        
        if (font && [targetView respondsToSelector:@selector(setFont:)])
        {
            [targetView performSelector:@selector(setFont:) withObject:font];
        }
        
        if ([targetView respondsToSelector:@selector(setTextColor:)])
        {
            UIColor* color = self.color;
            if(color)
            {
                
                [targetView performSelector:@selector(setTextColor:) withObject:color];
                
            }
        }
        
        if([self shadowColor] && [targetView isKindOfClass:([UILabel class])])
        {
            UILabel* label = (UILabel*) targetView;
            label.shadowColor = [self shadowColor];
            label.shadowOffset = [self shadowOffset];
        }
    }
    
}

@end
