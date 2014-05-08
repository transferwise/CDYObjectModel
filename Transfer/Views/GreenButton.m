//
//  GreenButton.m
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "GreenButton.h"
#import "UIButton+Skinning.h"

@implementation GreenButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setBackgroundColor:[UIColor clearColor]];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self skinWithImage:[UIImage imageNamed:@"GreenButton.png"] insets:UIEdgeInsetsMake(0, 15, 0, 15)];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
}

@end
