//
//  HeaderTabView.h
//  Transfer
//
//  Created by Mats Trovik on 14/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeaderTabView;

@protocol HeaderTabViewDelegate <NSObject>

@optional
-(void)headerTabView:(HeaderTabView*)tabView tabTappedAtIndex:(NSUInteger)index;

@end

@interface HeaderTabView : UIView

@property (weak, nonatomic) IBOutlet UIView *separatorLine;
@property (nonatomic, strong) NSNumber* fixedTabWidth;

-(void)setSelectedIndex:(NSUInteger)index;

-(void)setTabTitles:(NSArray*)titles;


@property (weak,nonatomic) IBOutlet id<HeaderTabViewDelegate> delegate;


@end
