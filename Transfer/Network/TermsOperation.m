//
//  TermsOperation.m
//  Transfer
//
//  Created by Juhan Hion on 03.07.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "TermsOperation.h"
#import "TransferwiseOperation+Private.h"

NSString *const kTermsPath = @"/terms/get";

@interface TermsOperation ()

@property (nonatomic, strong) NSString *currencyCode;
@property (nonatomic, strong) NSString *countryCode;

@end

@implementation TermsOperation

- (instancetype)initWithSourceCurrency:(NSString *)currencyCode
							   country:(NSString *)countryCode
{
	NSAssert(currencyCode, @"currencyCode cannot be nil");
	NSAssert(countryCode, @"countryCode cannot be nil");
	
	self = [super init];
	if (self)
	{
		self.currencyCode = currencyCode;
		self.countryCode = countryCode;
	}
	return self;
}

+ (TermsOperation *)operationWithSourceCurrency:(NSString *)currencyCode
										country:(NSString *)countryCode
{
	return [[TermsOperation alloc] initWithSourceCurrency:currencyCode
												  country:countryCode];
}

- (void)execute
{
	NSString *path = [self addTokenToPath:kTermsPath];
	
	__weak TermsOperation *weakSelf = self;
	
	[self setOperationErrorHandler:^(NSError *error) {
		weakSelf.completionHandler(error, nil);
	}];
	
	[self setOperationSuccessHandler:^(NSDictionary *response) {
		weakSelf.completionHandler(nil, response);
	}];
	
	NSDictionary *data = @{@"currency": self.currencyCode,
						   @"country": self.countryCode};
	
	
	[self getDataFromPath:path
				   params:data];
}

@end
