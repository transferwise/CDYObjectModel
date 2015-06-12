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
#import "ObjectModel+RecipientTypes.h"
#import "ObjectModel+CurrencyPairs.h"

NSString *const kCurrencyPairsPath = @"/currency/pairs";

static NSMutableSet *allCurrencyPairsOperationsWaitingForResponse;

@implementation CurrencyPairsOperation

- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must use [%@ %@] instead",
                                                                     NSStringFromClass([self class]),
                                                                     NSStringFromSelector(@selector(pairsOperation))]
                                 userInfo:nil];
    return nil;
}

- (id)initPrivate
{
    self = [super init];
    if (self)
	{

    }
    return self;
}

- (void)execute
{
    if(allCurrencyPairsOperationsWaitingForResponse)
    {
        [allCurrencyPairsOperationsWaitingForResponse addObject:self];
    }
    else
    {
        allCurrencyPairsOperationsWaitingForResponse = [NSMutableSet setWithObject:self];
        
        NSString *path = [self addTokenToPath:kCurrencyPairsPath];
        
        __block __weak CurrencyPairsOperation *weakSelf = self;
        [self setOperationErrorHandler:^(NSError *error) {
            MCLog(@"Currency pairs error:%@", error);
            for (CurrencyPairsOperation* operation in allCurrencyPairsOperationsWaitingForResponse)
            {
                operation.currenciesHandler(error);
            }
            allCurrencyPairsOperationsWaitingForResponse = nil;
        }];
        
        [self setOperationSuccessHandler:^(NSDictionary *response) {
            [weakSelf.workModel.managedObjectContext performBlock:^{
                NSArray *pairs = response[@"sourceCurrencies"];
                MCLog(@"Retrieved %lu paris", (unsigned long)[pairs count]);
                
                [weakSelf.workModel hideExistingPairSources];
                
                NSUInteger index = 0;
                for (NSDictionary *data in pairs) {
                    [weakSelf.workModel createOrUpdatePairWithData:data index:index++];
                }
                
                [weakSelf.workModel saveContext:^{
                    for (CurrencyPairsOperation* operation in allCurrencyPairsOperationsWaitingForResponse)
                    {
                        operation.currenciesHandler(nil);
                    }
                    allCurrencyPairsOperationsWaitingForResponse = nil;
                }];
            }];
        }];
        
        [self getDataFromPath:path];
    }
}

+ (CurrencyPairsOperation *)pairsOperation
{
    return [[CurrencyPairsOperation alloc] initPrivate];
}

@end
