//
//  HeaderTabView.m
//  Transfer
//
//  Created by Mats Trovik on 14/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "HeaderTabView.h"
#import "Constants.h"
#import "MOMStyle.h"

@interface HeaderTabView ()

@property (nonatomic, weak) UIButton * lastSelectedButton;
@property (strong, nonatomic) NSMutableArray *presentedButtons;


@end

@implementation HeaderTabView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect newFrame = self.separatorLine.frame;
    newFrame.size.height = 1.0f/[[UIScreen mainScreen] scale];
    newFrame.origin.y += (1.0f - newFrame.size.height);
    self.separatorLine.frame = newFrame;
}

-(void)setTabTitles:(NSArray*)titles
{
    
    for (UIView *presented in self.presentedButtons) {
        [presented removeFromSuperview];
    }
    
    for (UIView *view in self.subviews) {
        //Removing the separation lines
        if(CGRectGetWidth(view.frame) == 1)
        [view removeFromSuperview];
    }
    
    self.presentedButtons = [NSMutableArray array];
    
    CGFloat groupedCellWidth = CGRectGetWidth(self.frame) - 20;
    CGFloat gap = IPAD?10.0f:4.0f;
    NSUInteger index = 0;
    
    for (NSString* title in titles) {
    UIButton *button = [self createButton];
    [button setTitle:title forState:UIControlStateNormal];
    CGRect frame = CGRectMake(groupedCellWidth / titles.count * index + 10.0 + gap/2 , 0, (groupedCellWidth / titles.count) - gap, CGRectGetHeight(self.frame));
    [button setFrame:frame];
    
    [self addSubview:button];
    [self.presentedButtons addObject:button];
    index ++;

    }
}

- (UIButton *)createButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    [button setBackgroundImage:[UIImage imageNamed:@"DeselectedTab"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"SelectedTab"] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:@"HighlightedTab"] forState:UIControlStateHighlighted];
    button.fontStyle = @"medium.@17.CoreFont";
    button.selectedFontStyle = @"medium.@17.TWElectricBlue";
    [button addTarget:self action:@selector(tabTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)setSelectedIndex:(NSUInteger)index
{
    [self setSelectedButton:self.presentedButtons[index]];
}

-(void)setSelectedButton:(UIButton*)button
{
    self.lastSelectedButton.selected = NO;
    self.lastSelectedButton = button;
    self.lastSelectedButton.selected = YES;
}

- (void)tabTapped:(UIButton*)sender {
    NSUInteger index = [self.presentedButtons indexOfObject:sender];
    [self setSelectedButton:sender];
    if([self.delegate respondsToSelector:@selector(headerTabView:tabTappedAtIndex:)])
    {
        [self.delegate headerTabView:self tabTappedAtIndex:index];
    }
}

@end
