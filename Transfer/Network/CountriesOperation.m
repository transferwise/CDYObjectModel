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
#import "Country.h"

NSString *const kCountriesPath = @"/user/countries";

@implementation CountriesOperation

- (void)execute {
    NSString *path = [self addTokenToPath:kCountriesPath];

    __block __weak CountriesOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.completionHandler(nil, error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        NSArray *countries = response[@"countries"];
        MCLog(@"Retrieved %d countries", [countries count]);
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:[countries count]];
        for (NSDictionary *data in countries) {
            Country *country = [Country countryWithData:data];
            [result addObject:country];
        }

        [result sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            Country *one = obj1;
            Country *two = obj2;
            return [one.name compare:two.name options:NSCaseInsensitiveSearch];
        }];

        weakSelf.completionHandler([NSArray arrayWithArray:result], nil);
    }];

    [self getDataFromPath:path];
}

+ (CountriesOperation *)operation {
    return [[CountriesOperation alloc] init];
}

@end
