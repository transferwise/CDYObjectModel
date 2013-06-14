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
        }];
    }
}


@end
