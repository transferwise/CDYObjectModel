//
//  TabView.m
//  Transfer
//
//  Created by Mats Trovik on 20/05/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TabCell.h"
#import "MOMStyle.h"

@implementation TabItem

-(id)init
{
    self = [super init];
    if(self)
    {
        _textColor = [UIColor colorFromStyle:@"CoreFont"];
        _textSelectedColor = [UIColor colorFromStyle:@"TWElectricBlue"];

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
        self.titleLabel.textColor = self.currentItem.textSelectedColor;
    }
    else
    {
        self.backgroundColor = self.currentItem.deSelectedColor;
        self.titleLabel.textColor = self.currentItem.textColor;
    }
}

-(void)configureForHighlightedState
{
    self.backgroundColor = self.currentItem.highlightedColor;
}



@end
