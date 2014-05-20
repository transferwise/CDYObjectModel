//
//  TabView.m
//  Transfer
//
//  Created by Mats Trovik on 20/05/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TabCell.h"

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
        self.titleLabel.alpha = 0.75f;
        self.iconImage.alpha = 0.75f;
    }
}



@end
