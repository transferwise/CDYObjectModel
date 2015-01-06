//
//  XCTestCase+Exceptions.m
//  Transfer
//
//  Created by Juhan Hion on 06.01.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//
//  Idea from here: http://www.alexkolov.com/exception-testing-in-swift

#import "XCTestCase+Exceptions.h"

@implementation XCTestCase (Exceptions)

- (void)XCTAssertThrows:(void (^)(void))block :(NSString *)message
{
	[self XCTAssertThrowsSpecific:block :nil :message];
}

- (void)XCTAssertThrowsSpecific:(void (^)(void))block :(NSString *)exceptionName :(NSString *)message
{
	BOOL __didThrow = NO;
	@try
	{
		block();
	}
	@catch (NSException *exception)
	{
		__didThrow = YES;
		
		if (exceptionName)
		{
			XCTAssertEqualObjects(exception.name, exceptionName, @"%@", message);
		}
	}
	@catch (...)
	{
		__didThrow = YES;
		XCTFail(@"%@", message);
	}
	
	if (!__didThrow)
	{
		XCTFail(@"%@", message);
	}
}

@end
