//
//  NSObjectNSNullTests.swift
//  Transfer
//
//  Created by Juhan Hion on 19.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

import UIKit
import XCTest

class NSObjectNSNullTests: XCTestCase
{
	func testGetObjectOrNsNullReturnsObjectWhenObjectExists()
	{
		let o : NSObject = NSObject()
		
		let result : NSObject = NSObject.getObjectOrNsNull(o) as NSObject;
		
		XCTAssertNotNil(result, "result can't be nil");
		XCTAssertEqual(result as NSObject, o, "invalid result returned");
	}
	
    func testGetObjectOrNsNullReturnsNsNullWhenObjectIsNil()
	{
		let o : NSObject? = nil
		
		let result: AnyObject? = NSObject.getObjectOrNsNull(o);
		
		XCTAssertNotNil(result, "result can't be nil");
		XCTAssertEqual(result! as NSNull, NSNull(), "invalid result returned");
	}
	
	func testGetObjectOrNsNullReturnsNsNullWhenObjectIsNsNull()
	{
		let o : NSNull = NSNull()
		
		let result: AnyObject? = NSObject.getObjectOrNsNull(o);
		
		XCTAssertNotNil(result, "result can't be nil");
		XCTAssertEqual(result! as NSNull, NSNull(), "invalid result returned");
	}
	
	func testGetObjectOrNilReturnsObjectWheObjectExists()
	{
		let o : NSObject = NSObject()
		
		let result : NSObject = NSObject.getObjectOrNil(o) as NSObject;
		
		XCTAssertNotNil(result, "result can't be nil");
		XCTAssertEqual(result as NSObject, o, "invalid result returned");
	}

	func testGetObjectOrNilReturnsNilWhenObjectIsNil()
	{
		let o : NSObject? = nil
		
		let result: AnyObject? = NSObject.getObjectOrNil(o);
		
		XCTAssertNil(result, "result can't be an object");
	}
	
	func testGetObjectOrNilReturnsNilWhenObjectIsNsNull()
	{
		let o : NSNull = NSNull()
		
		let result: AnyObject? = NSObject.getObjectOrNil(o);
		
		XCTAssertNil(result, "result can't be an object");
	}
}
