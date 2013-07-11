//
//  RecipientTypesOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^RecipientTypesBlock)(NSError *error);

@interface RecipientTypesOperation : TransferwiseOperation

@property (nonatomic, copy) RecipientTypesBlock resultHandler;

+ (RecipientTypesOperation *)operation;

@end
