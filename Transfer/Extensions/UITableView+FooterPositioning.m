//
//  UITableView+FooterPositioning.m
//  Transfer
//
//  Created by Henri Mägi on 14.06.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "UITableView+FooterPositioning.h"

@implementation UITableView (FooterPositioning)

- (void)adjustFooterViewSize
{    
    CGFloat sizeDiff = self.frame.size.height - self.contentSize.height-5;
    if (sizeDiff > 0) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect footerFrame = self.tableFooterView.frame;
            footerFrame.size.height += sizeDiff;
            self.tableFooterView.frame = footerFrame;
            [self setTableFooterView:self.tableFooterView];
        }];
    }
}

- (void)adjustFooterViewSizeForMinimumHeight:(CGFloat)height
{
    NSLog(@"frame: %f", self.frame.size.height);
    NSLog(@"content: %f", self.contentSize.height);
    
    CGFloat footerDiff = self.tableFooterView.frame.size.height - height;
    CGFloat sizeDiff = self.frame.size.height - self.contentSize.height-5;
    CGFloat newHeight = 0;
    if (sizeDiff > 0) {
        newHeight = sizeDiff;
    } else if(sizeDiff != 0 && footerDiff > 0)
        newHeight = -footerDiff;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect footerFrame = self.tableFooterView.frame;
        footerFrame.size.height += newHeight;
        self.tableFooterView.frame = footerFrame;
    }];
    
    // Needed so that self.contentSize would change
    [self setTableFooterView:self.tableFooterView];
}


@end
