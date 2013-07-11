//
//  PlainPayment.h
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PlainRecipient;

@interface PlainPayment : NSObject

@property (nonatomic, strong, readonly) PlainRecipient *settlementRecipient;

+ (PlainPayment *)paymentWithData:(NSDictionary *)data;
- (NSString *)localizedStatus;
- (NSString *)recipientName;
- (NSString *)transferredAmountString;
- (NSString *)latestChangeTimeString;
- (NSString *)payInWithCurrency;
- (BOOL)isActive;

@end
