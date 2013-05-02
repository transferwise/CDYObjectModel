//
//  CurrencyPairsOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 4/19/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "CurrencyPairsOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Constants.h"
#import "ObjectModel+CurrencyPairs.h"
#import "CurrencyPair.h"

NSString *const kCurrencyPairsPath = @"/api/v1/public/currency/pairs";

@implementation CurrencyPairsOperation

- (void)execute {
    __block __weak CurrencyPairsOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        MCLog(@"Cueency pairs error:%@", error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        NSArray *pairs = response[@"pairs"];
        MCLog(@"Retrieved %d paris", [pairs count]);

        NSArray *existingPairs = [weakSelf.objectModel listAllCurrencyPairs];
        NSArray *addedPairs = [pairs filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            NSDictionary *evaluated = evaluatedObject;
            NSString *source = evaluated[@"source"];
            NSString *target = evaluated[@"target"];

            for (CurrencyPair *pair in existingPairs) {
                if ([source isEqualToString:pair.source] && [target isEqualToString:pair.target]) {
                    return NO;
                }
            }

            return YES;
        }]];

        NSArray *removedPairs = [existingPairs filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            CurrencyPair *pair = evaluatedObject;

            for (NSDictionary *data in pairs) {
                NSString *source = data[@"source"];
                NSString *target = data[@"target"];

                if ([source isEqualToString:pair.source] && [target isEqualToString:pair.target]) {
                    return NO;
                }
            }

            return YES;
        }]];

        MCLog(@"%d pairs added", [addedPairs count]);
        MCLog(@"%d pairs removed", [removedPairs count]);

        for (CurrencyPair *pair in removedPairs) {
            [weakSelf.objectModel deleteObject:pair saveAfter:NO];
        }

        for (NSDictionary *added in addedPairs) {
            [weakSelf.objectModel addPairWithData:added];
        }

        [weakSelf.objectModel saveContext];
    }];

    [self getDataFromPath:kCurrencyPairsPath];
}

+ (CurrencyPairsOperation *)pairsOperation {
    return [[CurrencyPairsOperation alloc] init];
}


@end
