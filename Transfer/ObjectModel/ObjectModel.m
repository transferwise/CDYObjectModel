//
//  ObjectModel.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel.h"
#import "Constants.h"
#import "ObjectModel+RecipientTypes.h"
#import "ObjectModel+Currencies.h"
#import "ObjectModel+CurrencyPairs.h"

@interface ObjectModel ()

@end

@implementation ObjectModel

- (id)init {
    self = [super initWithDataModelName:@"Transfer" storeType:NSSQLiteStoreType];
    if (self) {
        [self setWipeDatabaseOnSchemaConflict:YES];
    }

    return self;
}

- (void)loadBaseData {
    [self loadRecipientTypes];
    [self loadCurrencies];
    [self loadCurrencyPairs];
    [self saveContext];
}

- (void)loadCurrencyPairs {
    NSArray *pairs = [self dataFromJSONFile:@"currency_pairs"][@"sourceCurrencies"];
    NSUInteger index = 0;
    for (NSDictionary *pairData in pairs) {
        [self createOrUpdatePairWithData:pairData index:index++];
    }
}

- (void)loadCurrencies {
    NSArray *currencies = [self dataFromJSONFile:@"currencies"][@"currencies"];
    NSUInteger index = 0;
    for (NSDictionary *currency in currencies) {
        [self createOrUpdateCurrencyWithData:currency index:index++];
    }
}

- (void)loadRecipientTypes {
    NSArray *types = [self dataFromJSONFile:@"recipient_types"][@"recipients"];
    for (NSDictionary *type in types) {
        [self createOrUpdateRecipientTypeWithData:type];
    }
}

- (NSDictionary *)dataFromJSONFile:(NSString *)fileName {
    MCAssert(fileName);
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    MCAssert(data);
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

-(void)clearUserRelatedData
{
    [self.managedObjectContext performBlockAndWait:^{
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Payment"];
        fetchRequest.returnsObjectsAsFaults = YES;
        NSArray* result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        for (NSManagedObject* toDelete in result)
        {
            [self.managedObjectContext deleteObject:toDelete];
        }
        
        fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Recipient"];
        fetchRequest.returnsObjectsAsFaults = YES;
        result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        for (NSManagedObject* toDelete in result)
        {
            [self.managedObjectContext deleteObject:toDelete];
        }
        
        fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
        fetchRequest.returnsObjectsAsFaults = YES;
        result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        for (NSManagedObject* toDelete in result)
        {
            [self.managedObjectContext deleteObject:toDelete];
        }
        
        [self saveContext];
        
    }];
}

@end
