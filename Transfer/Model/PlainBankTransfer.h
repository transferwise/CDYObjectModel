//
//  PlainBankTransfer.h
//  Transfer
//
//  Created by Henri Mägi on 10.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlainRecipient.h"

@interface PlainBankTransfer : NSObject

@property (strong, nonatomic, readonly) NSString *paymentId;
@property (strong, nonatomic, readonly) NSString *currency;
@property (strong, nonatomic, readonly) PlainRecipient *settlementAccount;

+ (PlainBankTransfer *)transferWithData:(NSDictionary *)data;

- (NSString *)formattedAmount;

@end
