//
//  NSStringNullStringTests.swift
//  Transfer
//
//  Created by Juhan Hion on 04.05.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

import XCTest

class NSStringNullStringTests: XCTestCase {

	let stringWithValue: String = "asdf"
	let stringWithNullAsValue: String = "null"
	
	func testReturnsStringValue()
	{
		XCTAssertEqual(stringWithValue.getNullOnNullAsValue(), stringWithValue, "invalid value returned")
	}

	func testReturnsNilOnNullAsValue()
	{
		XCTAssertNil(stringWithNullAsValue.getNullOnNullAsValue(), "invalid value returned")
	}
}
