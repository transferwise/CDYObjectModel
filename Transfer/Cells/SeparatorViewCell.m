//
//  SeparatorViewCell.m
//  Transfer
//
//  Created by Juhan Hion on 26.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "SeparatorViewCell.h"
#import "UIView+SeparatorLine.h"

@implementation SeparatorViewCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    if (!self.separatorLine)
    {
        self.separatorLine = [UIView getSeparatorLineWithParentFrame:self.contentView.frame
													   showFullWidth:self.showFullWidth];
        [self.contentView addSubview:self.separatorLine];
    }
}

@end
