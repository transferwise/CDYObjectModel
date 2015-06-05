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
#import "CurrencyPairsOperation.h"

#define kCurrencyUpdateFrequency (18000)

NSString *const kCurrencyListPath = @"/currency/list";

@interface CurrenciesOperation ()

@property (nonatomic, strong) RecipientTypesOperation *recipientTypesOperation;
@property (nonatomic, strong) CurrencyPairsOperation *currencyPairsOperation;

@end

static NSMutableSet *allCurrenciesOperationsWaitingForResponse;
static NSDate* lastSuccessTimestamp;

@implementation CurrenciesOperation

- (void)execute {
    
    if(lastSuccessTimestamp && ABS([lastSuccessTimestamp timeIntervalSinceNow]) < kCurrencyUpdateFrequency)
    {
        MCLog(@"Calling to update currencies within 5 minutes of last attempt");
        //We updated currencies within the last 5 minutes. Pretend that everything went well.
        self.resultHandler(nil);
        return;
    }
    
    if(allCurrenciesOperationsWaitingForResponse)
    {
        [allCurrenciesOperationsWaitingForResponse addObject:self];
    }
    else
    {
        allCurrenciesOperationsWaitingForResponse = [NSMutableSet setWithObject:self];
        
        NSString *path = [self addTokenToPath:kCurrencyListPath];
        
        __block __weak CurrenciesOperation *weakSelf = self;
        [self setOperationErrorHandler:^(NSError *error) {
            [weakSelf reportResult:error];
        }];
        
        [self setOperationSuccessHandler:^(NSDictionary *response) {
            [weakSelf.workModel.managedObjectContext performBlock:^{
                NSArray *currencies = response[@"currencies"];
                MCLog(@"Pulled %lu currencies", (unsigned long)[currencies count]);
                
                void (^persistingBlock)() = ^() {
                    [weakSelf.workModel.managedObjectContext performBlock:^{
                        NSUInteger index = 0;
                        for (NSDictionary *data in currencies) {
                            [weakSelf.workModel createOrUpdateCurrencyWithData:data index:index++];
                        }
                        
                        [weakSelf.workModel saveContext:^{
                            CurrencyPairsOperation *operation = [CurrencyPairsOperation pairsOperation];
                            [weakSelf setCurrencyPairsOperation:operation];
                            [operation setObjectModel:weakSelf.objectModel];
                            
                            
                            [operation setCurrenciesHandler:^(NSError *error) {
                                [weakSelf reportResult:error];
                                lastSuccessTimestamp = [NSDate date];
                            }];
                            
                            [operation setObjectModel:weakSelf.objectModel];
                            [operation execute];
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
}

-(void)reportResult:(NSError*)error
{
    for (CurrenciesOperation* operation in allCurrenciesOperationsWaitingForResponse)
    {
        operation.resultHandler(error);
    }
    allCurrenciesOperationsWaitingForResponse = nil;
}

- (void)pullRecipientTypesWithCompletionHandler:(void (^)())completion {
    RecipientTypesOperation *operation = [RecipientTypesOperation operation];
    [self setRecipientTypesOperation:operation];
    __weak typeof(self) weakSelf = self;
    [operation setObjectModel:self.objectModel];
    [operation setResultHandler:^(NSError *error, NSArray* returnedRecipientTypeIdentifiers) {
        if (error)
		{
            [weakSelf reportResult:error];
            return;
        }

        completion();
    }];

    [operation execute];
}

- (BOOL)haveAllNeededRecipientTypes:(NSArray *)currencies
{
    for (NSDictionary *currencyData in currencies)
	{
        NSArray *types = currencyData[@"recipientTypes"];
        for (NSString *type in types)
		{
            if (![self.objectModel haveRecipientTypeWithCode:type])
			{
                MCLog(@"Mossing type %@", type);
                return NO;
            }
        }
    }

    return YES;
}

+ (CurrenciesOperation *)operation
{
    return [[CurrenciesOperation alloc] init];
}

@end
