//
//  PaymentsOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^PaymentsResponseBlock)(NSInteger totalCount, NSError *error);

@interface PaymentsOperation : TransferwiseOperation

@property (nonatomic, copy) PaymentsResponseBlock completion;

+ (PaymentsOperation *)operationWithOffset:(NSInteger)offset;

@end
