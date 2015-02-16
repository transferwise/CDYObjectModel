//
//  CurrencyLoader.h
//  Transfer
//
//  Created by Juhan Hion on 13.02.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrenciesOperation.h"

@interface CurrencyLoader : NSObject

- (id)init __attribute__((unavailable("init unavailable, use sharedInstance")));
+ (CurrencyLoader *)sharedInstanceWithObjectModel:(ObjectModel *)objectModel;

- (void)getCurrencieWithSuccessBlock:(CurrencyBlock)successBlock;

@end
