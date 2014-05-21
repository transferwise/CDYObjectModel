//
//  MOMStyle
//
//  Created by Mats Trovik on 15/11/2013.
//  Copyright (c) 2014 Matsomatic Limited All rights reserved.
//

#import "MOMStyle.h"
@class MOMAppearanceStyle;

@interface MOMStyle ()

@property (nonatomic, strong) MOMStyle* child;
@property (nonatomic, strong) MOMStyle* compositeStyle;

@end

@implementation MOMStyle

-(instancetype)copyWithZone:(NSZone *)zone
{
    MOMStyle* copy = [[[self class] alloc] init];
    MOMStyle* styleIterator = self.child ;
    while (styleIterator)
    {
        MOMStyle* childStyle = [styleIterator copy];
        childStyle.child = nil;
        [copy addStyle:childStyle];
        styleIterator = styleIterator.child;
        
    }
    copy.compositeStyle = self.compositeStyle;
    return copy;
}

-(instancetype)initWithCompositeStyle:(MOMStyle*)compositeStyle
{
    self = [super init];
    if(self)
    {
        if ([compositeStyle isKindOfClass:[self class]] && !compositeStyle.child)
        {
            _compositeStyle = compositeStyle;
        }
        else
        {
            self = nil;
        }
    }
    
    return self;
}

-(instancetype)styleWrappedAsComposite
{
    return [[self.class alloc] initWithCompositeStyle:self];
}

-(void)applyColorStyleToView:(UIView *)targetView forControlState:(UIControlState)controlState{
    if(self.child)
    {
        [self.child applyColorStyleToView:targetView forControlState:controlState];
    }
    return;
}

-(void)applyFontStyleToView:(UIView *)targetView forControlState:(UIControlState)controlState{
    if(self.child)
    {
        [self.child applyFontStyleToView:targetView forControlState:controlState];
    }
    return;
}

-(void)applyAppearanceStyleToView:(UIView *)targetView
{
    if([self isKindOfClass:[MOMAppearanceStyle class]])
    {
        MOMAppearanceStyle* appearanceStyleSelf = (MOMAppearanceStyle*) (self.compositeStyle?:self);
        ApplyAppearanceBlock appearanceBlock = appearanceStyleSelf.apperanceBlock;
        if(appearanceBlock)
        {
            appearanceStyleSelf.apperanceBlock(targetView);
        }
        
        if(appearanceStyleSelf.child)
        {
            [appearanceStyleSelf.child applyAppearanceStyleToView:targetView];
        }
    }
    return;
}

-(void)addStyle:(MOMStyle*)style
{
    if(self.child)
    {
        [self.child addStyle:style];
    }
    else
    {
        self.child = style;
    }
}

-(NSString*)description
{
    NSString* result = [[self class] description];
    if(self.child)
    {
        [result stringByAppendingString:[NSString stringWithFormat:@"- %@\n",[self.child description]]];
    }
    return result;
}

@end


@implementation MOMAppearanceStyle

-(void)addStyle:(MOMStyle*)style
{
    if([style isKindOfClass:[MOMAppearanceStyle class]])
    {
        [super addStyle:style];
    }
}

-(ApplyAppearanceBlock)apperanceBlock
{
    return nil;
}

@end