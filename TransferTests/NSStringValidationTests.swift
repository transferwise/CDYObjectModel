//
//  NSStringValidationTests.swift
//  Transfer
//
//  Created by Juhan Hion on 20.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

import UIKit
import XCTest

class NSStringValidationTests: XCTestCase
{
	func testIsValidPhoneNumberReturnsInvalidForTooShort()
	{
		XCTAssertFalse("1".isValidPhoneNumber(), "not a valid phone number")
		XCTAssertFalse("123".isValidPhoneNumber(), "not a valid phone number")
    }
	
	func testIsValidPhoneNumberReturnsInvalidForTooLong()
	{		XCTAssertFalse("1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456".isValidPhoneNumber(), "not a valid phone number")
	}
	
	func testIsValidPhoneNumberReturnsValidForNumeric()
	{
		XCTAssertTrue("11223344".isValidPhoneNumber(), "is a valid phone number")
	}
	
	func testIsValidPhoneNumberReturnsValidForStartingWithPlusNumberic()
	{
		XCTAssertTrue("+11223344".isValidPhoneNumber(), "is a valid phone number")
	}
	
	func testIsValidPhoneNumberReturnsValidForStartingWithPlusAndSpacesNumberic()
	{
		XCTAssertTrue("+112 233 44".isValidPhoneNumber(), "is a valid phone number")
	}
	
	func testIsValidPhoneNumberReturnsValidForContainingChars()
	{
		XCTAssertTrue("1122a344".isValidPhoneNumber(), "is a valid phone number")
	}
}
