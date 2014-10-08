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
@property (weak, nonatomic) IBOutlet UIView *flashView;

@end

@implementation TabCell

-(void)awakeFromNib
{
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

-(void)configureWithTabItem:(TabItem*)item
{
    self.currentItem = item;
    self.titleLabel.text = item.title;
    self.iconImage.image = item.icon;
    [self configureForSelectedState:NO];
    self.flashView.backgroundColor = item.flashColor;
}

-(void)configureForSelectedState:(BOOL)selected
{
    [super setSelected:selected];
    
    if(selected)
    {
        self.backgroundColor = self.currentItem.selectedColor;
        self.titleLabel.textColor = self.currentItem.textSelectedColor;
        self.iconImage.image = self.currentItem.selectedIcon?:self.currentItem.icon;
    }
    else
    {
        self.backgroundColor = self.currentItem.deSelectedColor;
        self.titleLabel.textColor = self.currentItem.textColor;
        self.iconImage.image = self.currentItem.icon;
    }
}

-(void)configureForHighlightedState
{
    self.backgroundColor = self.currentItem.highlightedColor;
    self.iconImage.image = self.currentItem.selectedIcon?:self.currentItem.icon;
      self.titleLabel.textColor = self.currentItem.textSelectedColor;
}

-(void)setFlashOn:(BOOL)turnOn
{
    if(turnOn)
    {
        self.flashView.hidden = NO;
        [self animateFlash];
    }
    else
    {
        self.flashView.hidden = YES;
    }
}

-(void)animateFlash
{
    if(!self.flashView.hidden)
    {
        self.flashView.alpha=0.0f;
        [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.flashView.alpha=1.0f;
        } completion:^(BOOL finished) {
            if(finished)
                [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.flashView.alpha=0.0f;
                } completion:^(BOOL finished) {
                    if(finished)
                    {
                        [self animateFlash];
                    }
                
            }];

        }];
    }
}

@end
