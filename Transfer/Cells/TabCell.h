//
//  TabView.h
//  Transfer
//
//  Created by Mats Trovik on 20/05/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabItem;

typedef BOOL(^TabItemActionBlock)(TabItem*);

@interface TabItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIImage *selectedIcon;
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) TabItemActionBlock actionBlock;

@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *deSelectedColor;
@property (nonatomic, strong) UIColor *highlightedColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *textSelectedColor;

@property (nonatomic, assign) CGFloat deselectedAlpha;


@end

@interface TabCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *iconImage;

-(void)configureWithTabItem:(TabItem*)item;
-(void)configureForSelectedState:(BOOL)selected;
-(void)configureForHighlightedState;

@end
