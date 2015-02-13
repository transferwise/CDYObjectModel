//
//  CurrencyLoader.m
//  Transfer
//
//  Created by Juhan Hion on 13.02.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "CurrencyLoader.h"
#import "TransferwiseOperation.h"

@interface CurrencyLoader ()

@property (strong, nonatomic) TransferwiseOperation *executedOperation;
@property (strong, nonatomic) ObjectModel *objectModel;

@end

@implementation CurrencyLoader
{
	dispatch_queue_t queue;
}

#pragma mark - Init
+ (CurrencyLoader *)sharedInstanceWithObjectModel:(ObjectModel *)objectModel
{
	static dispatch_once_t pred = 0;
	__strong static CurrencyLoader *sharedObject = nil;
	dispatch_once(&pred, ^{
		sharedObject = [[self alloc] initSingleton];
	});
	
	sharedObject.objectModel = objectModel;
	
	return sharedObject;
}

- (id)initSingleton
{
	self = [super init];
	if (self)
	{
		queue = dispatch_queue_create("com.transferwise.CurrenciesQueue", NULL);
	}
	return self;
}

#pragma mark - Queue operation
- (void)getCurrencieWithSuccessBlock:(CurrencyBlock)successBlock
{
	dispatch_async(queue, ^{
		CurrenciesOperation *currenciesOperation = [CurrenciesOperation operation];
		currenciesOperation.objectModel = self.objectModel;
		[self setExecutedOperation:currenciesOperation];
		[currenciesOperation setResultHandler:^(NSError* error)
		 {
			 successBlock(error);
		 }];
		[currenciesOperation execute];
	});
}

@end
