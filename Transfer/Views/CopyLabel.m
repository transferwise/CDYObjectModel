//
//  CopyLabel.m
//  Transfer
//
//  Created by Mats Trovik on 30/01/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "CopyLabel.h"

@implementation CopyLabel

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setup];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

-(void)setup
{
    [self setUserInteractionEnabled:YES];
    UIGestureRecognizer *longTouch = [[UILongPressGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(handleGesture:)];
    [self addGestureRecognizer:longTouch];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:doubleTap];
}

- (void)handleGesture:(UIGestureRecognizer*)recognizer
{
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (![menu isMenuVisible]) {
        [menu setTargetRect:self.frame inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
    }
    
}

- (void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.text];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
