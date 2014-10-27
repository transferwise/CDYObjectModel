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

/**
 *  Set to assign a specific tab width, (or minimum if used with @see overrideFixedWidthWithLongestTitle)
 *
 *  If this value is <= 0, the full width of the tab view will be split evenly into tabs.
 */
@property (nonatomic, assign) IBInspectable CGFloat fixedTabWidth;

/**
 *  if true, the longest title will determine the tab width, unless all titles are slimmer than the fixed tab width.
 *
 *  only effective if @see tabWidth is greater than 0
 */
@property (nonatomic, assign) IBInspectable BOOL overrideFixedWidthWithLongestTitle;

@property (nonatomic) NSUInteger selectedIndex;

-(void)setTabTitles:(NSArray*)titles;


@property (weak,nonatomic) IBOutlet id<HeaderTabViewDelegate> delegate;

@end
