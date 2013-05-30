//
//  PaymentInput.h
//  Transfer
//
//  Created by Jaanus Siim on 5/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentInput : NSObject

@property (nonatomic, strong) NSNumber *recipientId;
@property (nonatomic, copy) NSString *sourceCurrency;
@property (nonatomic, copy) NSString *targetCurrency;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *reference;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *verificationProvideLater;

- (NSDictionary *)data;

@end
