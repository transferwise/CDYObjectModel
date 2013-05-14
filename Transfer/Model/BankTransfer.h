//
//  BankTransfer.h
//  Transfer
//
//  Created by Henri Mägi on 10.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipient.h"

@interface BankTransfer : NSObject

@property (strong, nonatomic, readonly) NSString *paymentId;
@property (strong, nonatomic, readonly) NSString *currency;
@property (strong, nonatomic, readonly) Recipient *settlementAccount;

+ (BankTransfer *)transferWithData:(NSDictionary *)data;

- (NSString *)formattedAmount;

@end
