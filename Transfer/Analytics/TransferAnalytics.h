//
//  TransferAnalytics.h
//  Transfer
//
//  Created by Jaanus Siim on 26/03/14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ObjectModel;

@protocol TransferAnalytics <NSObject>

- (void)startScreenShown;
- (void)markLoggedIn;
- (void)confirmPaymentScreenShown;
- (void)didCreatePayment:(NSDictionary *)paymentDetails;
- (void)paymentPersonalProfileScreenShown;
- (void)paymentRecipientProfileScreenShown;

@end
