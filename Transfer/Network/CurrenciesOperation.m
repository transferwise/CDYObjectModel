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
#import "ObjectModel+RecipientTypes.h"
#import "ObjectModel+Currencies.h"
#import "RecipientTypesOperation.h"

NSString *const kCurrencyListPath = @"/currency/list";

@interface CurrenciesOperation ()

@property (nonatomic, strong) RecipientTypesOperation *operation;

@end

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
            MCLog(@"Pulled %lu currencies", [currencies count]);

            void (^persistingBlock)() = ^() {
                [weakSelf.workModel.managedObjectContext performBlock:^{
                    NSUInteger index = 0;
                    for (NSDictionary *data in currencies) {
                        [weakSelf.workModel createOrUpdateCurrencyWithData:data index:index++];
                    }

                    [weakSelf.workModel saveContext:^{
                        weakSelf.resultHandler(nil);
                    }];
                }];
            };

            if ([weakSelf haveAllNeededRecipientTypes:currencies]) {
                MCLog(@"Have all recipient types. Continue");
                persistingBlock();
            } else {
                MCLog(@"Need to pull missing recipient types");
                [weakSelf pullRecipientTypesWithCompletionHandler:persistingBlock];
            }
        }];
    }];

    [self getDataFromPath:path];
}

- (void)pullRecipientTypesWithCompletionHandler:(void (^)())completion {
    RecipientTypesOperation *operation = [RecipientTypesOperation operation];
    [self setOperation:operation];
    [operation setObjectModel:self.objectModel];
    [operation setResultHandler:^(NSError *error, NSArray* returnedRecipientTypeIdentifiers) {
        if (error) {
            self.resultHandler(error);
            return;
        }

        completion();
    }];

    [operation execute];
}

- (BOOL)haveAllNeededRecipientTypes:(NSArray *)currencies {
    for (NSDictionary *currencyData in currencies) {
        NSArray *types = currencyData[@"recipientTypes"];
        for (NSString *type in types) {
            if (![self.objectModel haveRecipientTypeWithCode:type]) {
                MCLog(@"Mossing type %@", type);
                return NO;
            }
        }
    }

    return YES;
}

+ (CurrenciesOperation *)operation {
    return [[CurrenciesOperation alloc] init];
}

@end
