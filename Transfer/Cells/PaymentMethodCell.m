//
//  PaymentMethodCell.m
//  Transfer
//
//  Created by Mats Trovik on 16/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "PaymentMethodCell.h"
#import "PayInMethod.h"
#import "UIView+SeparatorLine.h"
#import "NSString+Presentation.h"

@interface PaymentMethodCell ()

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, weak) UIView* separatorLine;

@end

@implementation PaymentMethodCell


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


-(void)configureWithPaymentMethod:(NSString *)method
					 fromCurrency:(NSString *)currencyCode
{
    self.method = method;
    NSString *titleKey = [NSString stringWithFormat:@"payment.method.%@",method];
	[self.button setTitle:[NSString localizedStringForKey:[NSString stringWithFormat:@"%@.%@", titleKey, currencyCode]
											 withFallback:titleKey] forState:UIControlStateNormal];
    NSString *descriptionKey = [NSString stringWithFormat:@"payment.method.description.%@", method];
    self.descriptionLabel.text = [NSString localizedStringForKey:descriptionKey
													withFallback:nil];
}

- (IBAction)actionButtonTapped:(id)sender {
    if([self.paymentMethodCellDelegate respondsToSelector:@selector(actionButtonTappedOnCell:withMethod:)])
    {
        [self.paymentMethodCellDelegate actionButtonTappedOnCell:self
													  withMethod:self.method];
    }
}
@end
