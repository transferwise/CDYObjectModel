//
//  ReferralLinksOperationTests.swift
//  Transfer
//
//  Created by Juhan Hion on 13.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

import UIKit
import XCTest

class ReferralLinksOperationTests: XCTestCase
{
	class TestReferralLinksOperation: ReferralLinksOperation
	{
		private var _result : () -> Void;
		
		private (set) var path : String?
		private (set) var params : [NSObject : AnyObject]!
		
		init(_ result : (() -> Void))
		{
			_result = result
		}
		
		override func getDataFromPath(path: String!, params: [NSObject : AnyObject]!)
		{
			self.params = params
			_result()
		}
		
		override func addTokenToPath(path: String!) -> String!
		{
			self.path = path
			return path
		}
	}
	
	override func setUp()
	{
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
	
	func testOperatinAddsExpectedTokenToPath()
	{
		let sut : TestReferralLinksOperation = TestReferralLinksOperation({ () -> Void in return })
		
		sut.execute()
		
		XCTAssertNotNil(sut.path, "path not set");
		XCTAssertTrue(sut.path == "/referral/links" , "invalid path set")
	}
	
	func testOperationAddsExpectedAppTypeToParameters()
	{
		let sut : TestReferralLinksOperation = TestReferralLinksOperation({ () -> Void in return })
		
		sut.execute()
		
		XCTAssertNotNil(sut.params, "params not set");
		XCTAssertEqual(sut.params.count, 1, "invlid number of params")
		XCTAssertNotNil(sut.params["invitePlatform"], "invitePlatform not submitted")
		XCTAssertTrue(sut.params["invitePlatform"] as NSString == TRWAppType, "invalid platform submitted")
	}

}
