//
//  TabViewController.h
//  Transfer
//
//  Created by Mats Trovik on 19/05/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabItem;

typedef BOOL(^TabItemActionBlock)(TabItem*);

@interface TabItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) TabItemActionBlock actionBlock;

@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *deSelectedColor;


@end

@interface TabViewController : UIViewController

@property (nonatomic, strong) UIColor *backgroundColor;

-(void)addItem:(TabItem*)newItem;

-(void)setItems:(NSArray*)items;

@end
