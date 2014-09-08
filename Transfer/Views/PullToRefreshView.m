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
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIView *fadeInCover;
@property (nonatomic, assign) BOOL endRefreshRequestedDuringDeceleration;
@property (nonatomic, assign) BOOL willDecelerate;

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation PullToRefreshView

+(PullToRefreshView*)addInstanceToScrollView:(UIScrollView*)scrollView
{
    PullToRefreshView *result = [[NSBundle mainBundle] loadNibNamed:@"PullToRefreshView" owner:self options:nil][0];
    [result addToScrollView:scrollView];
    return result;
}

-(void)addToScrollView:(UIScrollView*)scrollView
{
    self.frame = CGRectMake(0.0f, 0.0f, scrollView.bounds.size.width, 0.0f);
    [scrollView addSubview:self];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.image.image = [UIImage imageNamed:@"refreshFlag0"];
    self.scrollView = scrollView;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.willDecelerate = decelerate;
    if(self.endRefreshRequestedDuringDeceleration && !decelerate)
    {
        [self refreshComplete];
    }
    [self scrollViewDidEndDragging];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self scrollViewDidScroll];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.willDecelerate = NO;
    if (self.endRefreshRequestedDuringDeceleration)
    {
        [self refreshComplete];
    }
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
    if(self.displayLink)
    {
        return;
    }
    [self.scrollView bringSubviewToFront:self];
    if(!self.isRefreshing)
    {
        CGRect newFrame = self.frame;
        newFrame.origin.y = MIN(MAX([self verticalOffset],-self.targetHeight),0.0f);
        newFrame.size.height = -newFrame.origin.y;
        self.frame = newFrame;
        
        if(-[self verticalOffset] >= self.targetHeight)
        {
            self.label.text = NSLocalizedString(@"refresh.release",nil);
        }
        else
        {
            self.label.text = NSLocalizedString(@"refresh.pull",nil);
        }
        
           
           [self configureForOffset:MAX(-[self verticalOffset],0.0f)];
    }
}

-(void)configureForOffset:(CGFloat)offset
{
    offset = MIN(offset,self.targetHeight);
    self.fadeInCover. alpha = MAX(1.0f - offset/self.targetHeight, 0.0f);
}

-(void)configureForRefresh
{
    self.label.text = NSLocalizedString(@"refresh.refreshing",nil);
    [self animateFlag];
}

-(void)configureForRefreshComplete
{
    self.label.text = @"";
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
    if(self.willDecelerate)
    {
        self.endRefreshRequestedDuringDeceleration = YES;
        return;
    }
    
    if(self.isRefreshing)
    {
        self.endRefreshRequestedDuringDeceleration = NO;
        self.isRefreshing = NO;
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.top -= self.targetHeight;
        CGFloat offset = [self verticalOffset];
        if (offset < self.targetHeight)
        {
            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick)];
            [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

            
            [UIView animateWithDuration:(0.2f * ABS(self.scrollView.contentOffset.y / self.targetHeight)) animations:^{
                self.scrollView.contentOffset = CGPointZero;
            } completion:^(BOOL finished) {
                // Cleanup the display link
                [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                self.displayLink = nil;
                [self.scrollView setContentInset:insets];
            }];
        }
        else
        {
            [self.scrollView setContentInset:insets];
        }
        [self configureForRefreshComplete];

    }
}

- (void)displayLinkTick {
    CALayer *presentationLayer = (CALayer *)self.scrollView.layer.presentationLayer;
    CGPoint contentOffset = presentationLayer.bounds.origin;
    
    CGFloat verticalOffset = contentOffset.y + (self.scrollView.contentInset.top - self.targetHeight);
    CGRect newFrame = self.frame;
    newFrame.origin.y = MIN(MAX(verticalOffset,-self.targetHeight),0.0f);
    newFrame.size.height = -newFrame.origin.y;
    self.frame = newFrame;
    [self configureForOffset:MAX(-verticalOffset,0.0f)];

    
}

-(CGFloat)verticalOffset
{
    return self.scrollView.contentOffset.y+self.scrollView.contentInset.top;
}

-(void)animateFlag
{
    [UIView transitionWithView:self.image duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut animations:^{
        self.image.tag = ++self.image.tag%3;
        self.image.image = [UIImage imageNamed:[NSString stringWithFormat:@"refreshFlag%d",self.image.tag]];
    } completion:^(BOOL finished) {
        if (self.isRefreshing)
        {
            [self animateFlag];
        }
        else
        {
            self.image.image = [UIImage imageNamed:@"refreshFlag0"];
        }
    }];
}

@end
