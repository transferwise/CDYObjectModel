//
//  Payment.h
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Recipient;

@interface Payment : NSObject

@property (nonatomic, strong, readonly) Recipient *settlementRecipient;

+ (Payment *)paymentWithData:(NSDictionary *)data;
- (NSString *)localizedStatus;
- (NSString *)recipientName;
- (NSString *)transferredAmountString;
- (NSString *)latestChangeTimeString;
- (NSString *)payInWithCurrency;

@end
