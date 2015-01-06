//
//  XCTestCase+Exceptions.h
//  Transfer
//
//  Created by Juhan Hion on 06.01.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCTestCase (Exceptions)

- (void)XCTAssertThrows:(void (^)(void))block :(NSString *)message;
- (void)XCTAssertThrowsSpecific:(void (^)(void))block :(NSString *)name :(NSString *)message;

@end
