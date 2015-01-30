//
//  BankTransferDetailCell.m
//  Transfer
//
//  Created by Mats Trovik on 14/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "PlainPresentationCell.h"

@implementation PlainPresentationCell

-(void)awakeFromNib
{
    NSMutableOrderedSet* titleLabels = [NSMutableOrderedSet orderedSetWithArray:self.titleLabels];
    [titleLabels addObject:self.headerLabel];
    self.titleLabels = [titleLabels array];

    NSMutableOrderedSet* valueLabels = [NSMutableOrderedSet orderedSetWithArray:self.valueLabels];
    [valueLabels addObject:self.valueLabel];
    self.valueLabels = [valueLabels array];

}

- (void)configureWithTitle:(NSString *)title text:(NSString *)text {
    [self setTitles:title, nil];
    [self setValues:text, nil];
}

@end
