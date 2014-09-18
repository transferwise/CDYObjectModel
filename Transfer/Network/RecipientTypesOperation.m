//
//  RecipientTypesOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientTypesOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Constants.h"
#import "ObjectModel+RecipientTypes.h"

NSString *const kRecipientTypesPath = @"/recipient/listTypes";

@implementation RecipientTypesOperation

- (void)execute {
    NSString *path = [self addTokenToPath:kRecipientTypesPath];

    __block __weak RecipientTypesOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.resultHandler(error,nil);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        [weakSelf.workModel.managedObjectContext performBlock:^{
            NSArray *recipients = response[@"recipients"];
            MCLog(@"Pulled %lu receipient types", (unsigned long)[recipients count]);
            for (NSDictionary *data in recipients) {
                NSDictionary *dataToUse = data;
                if(weakSelf.sourceCurrency)
                {
                    NSMutableDictionary* mutableData = [NSMutableDictionary dictionaryWithDictionary:data];
                    BOOL addressRequired = [response[@"recipientAddressRequired"] boolValue];
                    mutableData[@"recipientAddressRequired"] = @(addressRequired);
                    dataToUse = mutableData;
                }
                [weakSelf.workModel createOrUpdateRecipientTypeWithData:dataToUse];
            }

            [weakSelf.workModel saveContext:^{
                weakSelf.resultHandler(nil, [recipients valueForKey:@"type"]);
            }];
        }];
    }];

    if(self.sourceCurrency)
    {
        [self getDataFromPath:path params:@{@"sourceCurrency":self.sourceCurrency, @"targetCurrency":self.targetCurrency, @"amount":self.amount, @"amountType":@"source"}];
    }
    else
    {
        [self getDataFromPath:path];
    }
}

+ (RecipientTypesOperation *)operation {
    return [[RecipientTypesOperation alloc] init];
}

@end
