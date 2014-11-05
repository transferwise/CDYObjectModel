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
@property (nonatomic, assign) CGFloat adaptiveMinWidth;
          

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

-(void)awakeFromNib
{
    if(!self.separatorLine)
    {
        UIView *separator = [[UIView alloc]initWithFrame:self.bounds];
        self.separatorLine = separator;
        separator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:separator];
    }
    self.separatorLine.bgStyle = @"corefont";
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect newFrame = self.separatorLine.frame;
    newFrame.size.height = 1.0f/[[UIScreen mainScreen] scale];
    newFrame.origin.y = self.bounds.size.height - newFrame.size.height;
    self.separatorLine.frame = newFrame;
    
    [self layoutButtons];
    
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
    
    self.adaptiveMinWidth = self.fixedTabWidth;
    
    for (NSString* title in titles) {
        UIButton *button = [self createButton];
        [button setTitle:title forState:UIControlStateNormal];
        [self insertSubview:button aboveSubview:self.separatorLine];
        [self.presentedButtons addObject:button];
        self.adaptiveMinWidth = MAX(self.adaptiveMinWidth, ceil([title sizeWithAttributes:@{NSFontAttributeName:[button.titleLabel font]}].width + 50.0f));
    }
    
    [self layoutButtons];
}

-(void)layoutButtons
{
    CGFloat margin = 10.0f;
    CGFloat groupedCellWidth = CGRectGetWidth(self.frame) - 2 * margin;
    CGFloat gap = IPAD?10.0f:4.0f;
    NSUInteger count = [self.presentedButtons count];
    
    CGFloat cellWidth = groupedCellWidth/count;
    if(self.fixedTabWidth > 0)
    {
        cellWidth = self.overrideFixedWidthWithLongestTitle?self.adaptiveMinWidth:self.fixedTabWidth + gap;
        groupedCellWidth = cellWidth * count;
        margin = (CGRectGetWidth(self.frame) - groupedCellWidth )/ 2;
    }
    
    [self.presentedButtons enumerateObjectsUsingBlock:^(id button, NSUInteger index, BOOL *stop) {
        CGRect frame = CGRectMake(cellWidth * index + margin + gap/2 , 0, (cellWidth) - gap, CGRectGetHeight(self.frame));
        [button setFrame:frame];
    }];
}

- (UIButton *)createButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    [button setBackgroundImage:[UIImage imageNamed:@"DeselectedTab"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"SelectedTab"] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:@"HighlightedTab"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"HighlightedTab"] forState:(UIControlStateHighlighted|UIControlStateSelected)];
    button.fontStyle = @"medium.@{15,17}.CoreFont";
    button.selectedFontStyle = @"medium.@{15,17}.TWElectricBlue";
    button.adjustsImageWhenHighlighted = NO;
    [button addTarget:self action:@selector(tabTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)setSelectedIndex:(NSUInteger)index
{
    [self setSelectedButton:self.presentedButtons[index]];
}

-(NSUInteger)selectedIndex
{
	return [self.presentedButtons indexOfObject:self.lastSelectedButton];
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

