//
//  PaymentMethodCell.h
//  Transfer
//
//  Created by Mats Trovik on 16/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PayInMethod;
@class PaymentMethodCell;

@protocol PaymentMethodCellDelegate <NSObject>

-(void)actionButtonTappedOnCell:(PaymentMethodCell*)cell withMethod:(PayInMethod*)method;

@end

@interface PaymentMethodCell : UITableViewCell

@property (nonatomic, weak) id<PaymentMethodCellDelegate> paymentMethodCellDelegate;

-(void)configureWithPaymentMethod:(PayInMethod*)method fromCurrency:(NSString *)currencyCode;

@end
