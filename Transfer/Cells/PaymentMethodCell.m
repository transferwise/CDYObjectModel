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


@interface PaymentMethodCell ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) UIView* separatorLine;
@property (nonatomic, weak) PayInMethod* method;

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


-(void)configureWithPaymentMethod:(PayInMethod*)method
{
    self.method = method;
    NSString *title = [NSString stringWithFormat:@"payment.method.%@",method.type];
    [self.button setTitle:NSLocalizedString(title,nil) forState:UIControlStateNormal];
    NSString *description = [NSString stringWithFormat:@"payment.method.description.%@",method.type];
    self.descriptionLabel.text = NSLocalizedString(description, nil);

}

- (IBAction)actionButtonTapped:(id)sender {
    if([self.paymentMethodCellDelegate respondsToSelector:@selector(actionButtonTappedOnCell:withMethod:)])
    {
        [self.paymentMethodCellDelegate actionButtonTappedOnCell:self withMethod:self.method];
    }
}
@end