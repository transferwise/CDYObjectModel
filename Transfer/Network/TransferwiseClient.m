//
//  TransferwiseClient.m
//  Transfer
//
//  Created by Jaanus Siim on 4/22/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseClient.h"
#import "Constants.h"
#import "CurrencyPairsOperation.h"

@interface TransferwiseClient ()

@property (nonatomic, strong) CurrencyPairsOperation *currencyOperation;

@end

@implementation TransferwiseClient

- (id)initSingleton {
    self = [super initWithBaseURL:[NSURL URLWithString:@"http://api-sandbox.transferwise.com"]];
    if (self) {

    }

    return self;
}

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must use [%@ %@] instead",
                                                                     NSStringFromClass([self class]),
                                                                     NSStringFromSelector(@selector(sharedClient))]
                                 userInfo:nil];
    return nil;
}

+ (TransferwiseClient *)sharedClient {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] initSingleton];
    });
}

- (void)updateCurrencyPairs {
    MCLog(@"Update pairs");
    CurrencyPairsOperation *operation = [CurrencyPairsOperation pairsOperation];
    [self setCurrencyOperation:operation];

    [operation setObjectModel:self.objectModel];

    [operation execute];
}

@end
