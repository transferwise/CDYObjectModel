//
//  GreenButton.m
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "GreenButton.h"
#import "UIButton+Skinning.h"
#import "MOMStyle.h"

@implementation GreenButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonSetup];

}

-(void)commonSetup
{
    self.compoundStyle = @"greenButton";
    self.exclusiveTouch = YES;
}

@end
