//
//  ObjectModel+PayInMethod.h
//  Transfer
//
//  Created by Mats Trovik on 18/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel.h"

@class Payment;
@class PayInMethod;

@interface ObjectModel (PayInMethod)

- (void)createOrUpdatePayInMethodsWithData:(NSArray*)data
								forPayment:(Payment*)payment;
- (PayInMethod *)payInMethodWithType:(NSString *)type;

@end
