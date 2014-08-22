//
//  PullToRefreshView.m
//  Transfer
//
//  Created by Mats Trovik on 29/05/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "PullToRefreshView.h"
#import "MOMStyle.h"

@interface PullToRefreshView ()
@property (nonatomic, weak)UIScrollView *scrollView;
@property (nonatomic, assign)BOOL isRefreshing;

@end

@implementation PullToRefreshView

+(PullToRefreshView*)addInstanceToScrollView:(UIScrollView*)scrollView
{
    PullToRefreshView *result = [[self alloc] init];
    [result addToScrollView:scrollView];
    return result;
}

-(void)addToScrollView:(UIScrollView*)scrollView
{
    self.frame = CGRectMake(0.0f, 0.0f, scrollView.bounds.size.width, 0.0f);
    [scrollView addSubview:self];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.clipsToBounds = YES;
    self.scrollView = scrollView;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self scrollViewDidEndDragging];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self scrollViewDidScroll];
}

-(void)scrollViewDidEndDragging
{
    if(-[self verticalOffset] >= self.targetHeight)
    {
        [self beginRefresh];
    }
}

-(void)scrollViewDidScroll
{
    [self.scrollView bringSubviewToFront:self];
    if(!self.isRefreshing)
    {
    CGRect newFrame = self.frame;
    newFrame.origin.y = MIN(MAX([self verticalOffset],-self.targetHeight),0.0f);
    newFrame.size.height = -newFrame.origin.y;
        self.frame = newFrame;
    [self configureForOffset:MAX(-[self verticalOffset],0.0f)];
    }
}

-(void)configureForOffset:(CGFloat)offset
{
    offset = MIN(offset,self.targetHeight);
    self.backgroundColor = [UIColor colorWithWhite:offset/self.targetHeight alpha:1.0f];
}

-(void)configureForRefresh
{
    self.backgroundColor = [UIColor colorFromStyle:@"TWElectricBlue"];
}

-(void)configureForRefreshComplete
{

}

-(void)beginRefresh
{
    if(!self.isRefreshing)
    {
        self.isRefreshing = YES;
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.top += self.targetHeight;
        [UIView animateWithDuration:0.2f animations:^(void) {
            [self.scrollView setContentInset:insets];
        }];
        
        [self configureForRefresh];
        if([self.delegate respondsToSelector:@selector(refreshRequested:)])
        {
            [self.delegate refreshRequested:self];
        }
    }
}

-(void)refreshComplete
{
    if(self.isRefreshing)
    {
        self.isRefreshing = NO;
        [self configureForRefreshComplete];
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.top -= self.targetHeight;
        [UIView animateWithDuration:0.2f animations:^(void) {
            [self.scrollView setContentInset:insets];
        }];
    }
}

-(CGFloat)verticalOffset
{
    return self.scrollView.contentOffset.y+self.scrollView.contentInset.top;
}

@end
