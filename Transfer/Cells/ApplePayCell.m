//
//  ApplePayCell.m
//  Transfer
//
//  Created by Juhan Hion on 09/07/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "ApplePayCell.h"
#import "UIView+SeparatorLine.h"
#import "NSString+Presentation.h"

@interface ApplePayCell ()

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) UIView* separatorLine;

@end

@implementation ApplePayCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    if (!self.separatorLine)
    {
        UIView * line = [UIView getSeparatorLineWithParentFrame:self.contentView.frame
                                                       showFullWidth:YES];
        self.separatorLine = line;
        [self.contentView addSubview:self.separatorLine];
    }
}

-(void)awakeFromNib
{
	self.descriptionLabel.text = [NSString localizedStringForKey:@"payment.method.description.apple.pay" withFallback:nil];
}

- (IBAction)actionButtonTapped:(id)sender
{
    if([self.applePayCellDelegate respondsToSelector:@selector(payButtonTappedOnCell:)])
    {
        [self.applePayCellDelegate payButtonTappedOnCell:self];
    }
}
@end
