//
//  RecipientTypesOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^RecipientTypesBlock)(NSError *error, NSArray* listOfRecipientTypeCodes);

@interface RecipientTypesOperation : TransferwiseOperation

@property (nonatomic, copy) RecipientTypesBlock resultHandler;
@property (nonatomic, copy) NSString* sourceCurrency;
@property (nonatomic, copy) NSString* targetCurrency;
@property (nonatomic, copy) NSNumber* amount;


+ (RecipientTypesOperation *)operation;

@end
