//
//  PullToRefreshView.h
//  Transfer
//
//  Created by Mats Trovik on 29/05/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PullToRefreshView;
@protocol PullToRefreshViewDelegate <NSObject>

-(void)refreshRequested:(PullToRefreshView*)refreshView;

@end

@interface PullToRefreshView : UIView<UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat targetHeight;
@property (nonatomic, weak) id<PullToRefreshViewDelegate> delegate;

+(PullToRefreshView*)addInstanceToScrollView:(UIScrollView*)scrollView;

-(void)addToScrollView:(UIScrollView*)scrollView;

-(void)refreshComplete;
@end
