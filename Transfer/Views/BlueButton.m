//
//  BlueButton.m
//  Transfer
//
//  Created by Juhan Hion on 17.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "BlueButton.h"

@implementation BlueButton

- (id)initWithFrame:(CGRect)frame
{
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
	[super configureWithTitleColor:@"white" titleFont:@"medium.@16" color:@"lightBlue3" highlightColor:@"blue"];
}

@end
