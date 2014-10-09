//
//  TabViewController.h
//  Transfer
//
//  Created by Mats Trovik on 19/05/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabCell.h"

@interface TabViewController : UIViewController

@property (nonatomic, assign) CGSize fixedSize;
@property (nonatomic, assign) NSInteger insertFlexibleSpaceAtIndex;
@property (nonatomic, strong) UIColor *defaultSelectedColor;
@property (nonatomic, strong) UIColor *defaultDeSelectedColor;
@property (nonatomic, strong) UIColor *defaultHighlightedColor;
@property (nonatomic, assign) UIEdgeInsets tabBarInsets;
@property (nonatomic, assign) BOOL centerVertically;


@property (weak, nonatomic) IBOutlet UICollectionView *tabBarCollectionView;
@property (weak, nonatomic) IBOutlet UIView *containerView;


-(void)addItem:(TabItem*)newItem;
-(void)setItems:(NSArray*)items;

-(void)selectItem:(TabItem *)newSelectedItem;
-(void)selectIndex:(NSUInteger)index;

-(void)turnOnFlashForItemAtIndex:(NSUInteger)index;
-(void)turnOffFlashForItemAtIndex:(NSUInteger)index;

@end
