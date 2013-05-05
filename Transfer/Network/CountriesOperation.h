//
//  CountriesOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 4/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^CountriesResponseBlock)(NSArray *countries, NSError *error);

@interface CountriesOperation : TransferwiseOperation

@property (nonatomic, copy) CountriesResponseBlock completionHandler;

+ (CountriesOperation *)operation;

@end
