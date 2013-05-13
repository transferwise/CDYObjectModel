//
//  Payment.h
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Payment : NSObject

+ (Payment *)paymentWithData:(NSDictionary *)data;
- (NSString *)localizedStatus;
- (NSString *)recipientName;
- (NSString *)transferredAmountString;

@end
