//
//  TabView.m
//  Transfer
//
//  Created by Mats Trovik on 20/05/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TabCell.h"

@implementation TabItem

-(id)init
{
    self = [super init];
    if(self)
    {
        _deselectedAlpha = 0.75;
        _selectedColor = [UIColor colorWithRed:31/255.0f green:39/255.0f blue:54/255.0f alpha:1.0f];
        _highlightedColor = [UIColor colorWithRed:49/255.0f green:67/255.0f blue:104/255.0f alpha:1.0f];

    }
    return self;
}

@end

@interface TabCell ()

@property (nonatomic, weak) TabItem* currentItem;

@end

@implementation TabCell

-(void)configureWithTabItem:(TabItem*)item
{
    self.currentItem = item;
    self.titleLabel.text = item.title;
    self.iconImage.image = item.icon;
    [self configureForSelectedState:NO];
}

-(void)configureForSelectedState:(BOOL)selected
{
    [super setSelected:selected];
    
    if(selected)
    {
        self.backgroundColor = self.currentItem.selectedColor;
        self.titleLabel.alpha = 1.0f;
        self.iconImage.alpha = 1.0f;
    }
    else
    {
        self.backgroundColor = self.currentItem.deSelectedColor;
        self.titleLabel.alpha = self.currentItem.deselectedAlpha;
        self.iconImage.alpha = self.currentItem.deselectedAlpha;
    }
}

-(void)configureForHighlightedState
{
    self.backgroundColor = self.currentItem.highlightedColor;
}



@end
