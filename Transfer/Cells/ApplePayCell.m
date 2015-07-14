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
@implementation ApplePayCell

-(void)configureWithPaymentMethod:(NSString *)method
					 fromCurrency:(NSString *)currencyCode
{
	self.method = method;
	self.descriptionLabel.text = [NSString localizedStringForKey:@"payment.method.description.apple.pay"
													withFallback:nil];
}

@end
