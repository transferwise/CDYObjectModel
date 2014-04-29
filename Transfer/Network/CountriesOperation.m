//
//  CountriesOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 4/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "CountriesOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Constants.h"
#import "ObjectModel+RecipientTypes.h"
#import "ObjectModel+Countries.h"

NSString *const kCountriesPath = @"/user/countries";

@implementation CountriesOperation

- (void)execute {
    if ([self.objectModel numberOfCountries] > 0) {
        self.completionHandler(nil);
        return;
    }

    NSString *path = [self addTokenToPath:kCountriesPath];

    __block __weak CountriesOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.completionHandler(error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        [weakSelf.workModel.managedObjectContext performBlock:^{
            NSArray *countries = response[@"countries"];
            MCLog(@"Retrieved %d countries", [countries count]);
            for (NSDictionary *data in countries) {
                [weakSelf.workModel addOrCreateCountryWithData:data];
            }

            [weakSelf.workModel saveContext:^{
                weakSelf.completionHandler(nil);
            }];
        }];
    }];

    [self getDataFromPath:path];
}

+ (CountriesOperation *)operation {
    return [[CountriesOperation alloc] init];
}

@end
