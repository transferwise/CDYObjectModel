//
//  CurrenciesOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "CurrenciesOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Constants.h"
#import "JCSObjectModel.h"
#import "ObjectModel+RecipientTypes.h"
#import "ObjectModel+Currencies.h"

NSString *const kCurrencyListPath = @"/currency/list";

@implementation CurrenciesOperation

- (void)execute {
    NSString *path = [self addTokenToPath:kCurrencyListPath];

    __block __weak CurrenciesOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.resultHandler(error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        [weakSelf.workModel.managedObjectContext performBlock:^{
            NSArray *currencies = response[@"currencies"];
            MCLog(@"Pulled %d currencies", [currencies count]);

            NSUInteger index = 0;
            for (NSDictionary *data in currencies) {
                [weakSelf.workModel createOrUpdateCurrencyWithData:data index:index++];
            }

            [weakSelf.workModel saveContext:^{
                weakSelf.resultHandler(nil);
            }];
        }];
    }];

    [self getDataFromPath:path];
}

+ (CurrenciesOperation *)operation {
    return [[CurrenciesOperation alloc] init];
}

@end
