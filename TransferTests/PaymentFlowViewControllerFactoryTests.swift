//
//  PaymentFlowViewControllerFactoryTests.swift
//  Transfer
//
//  Created by Juhan Hion on 05.01.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

import UIKit
import XCTest
import Foundation

class PaymentFlowViewControllerFactoryTests: XCTestCase
{
	var factory: PaymentFlowViewControllerFactory?
	var objectModel: ObjectModel?
	
    override func setUp()
	{
        super.setUp()
		
		objectModel = ObjectModel()
		factory = PaymentFlowViewControllerFactory(objectModel: objectModel)
	}
    
    override func tearDown()
	{
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testGetViewControllerReturnsCorrectPersonalPaymentProfile()
	{
		let controller = factory!.getViewControllerWithType(.PersonalPaymentProfileController, params: [kAllowProfileSwitch: true,
			kProfileIsExisting: true,
			kPersonalProfileValidator: NSNull()])
		
		XCTAssertNotNil(controller, "controller must exist")
	}

	//test all positive paths
	//- check correct type is returned
	//- check that all params are set
	//test each version for negative paths
	//- missing params
}
