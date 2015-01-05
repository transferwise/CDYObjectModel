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
	var validatorFactory: ValidatorFactory?
	
    override func setUp()
	{
        super.setUp()
		
		objectModel = ObjectModel()
		factory = PaymentFlowViewControllerFactory(objectModel: objectModel)
		validatorFactory = ValidatorFactory(objectModel: objectModel)
	}
    
    override func tearDown()
	{
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testGetViewControllerReturnsCorrectPersonalPaymentProfile()
	{
		let validator: AnyObject! = validatorFactory!.getValidatorWithType(.ValidatePersonalProfile)
		let controller = factory!.getViewControllerWithType(.PersonalPaymentProfileController, params: [kAllowProfileSwitch: true,
			kProfileIsExisting: true,
			kPersonalProfileValidator: validator])
		
		XCTAssertNotNil(controller, "controller must exist")
		XCTAssertTrue(controller is PersonalPaymentProfileViewController, "invalid type of controller")
		
		let concreteController = controller as PersonalPaymentProfileViewController
		
		XCTAssertTrue(concreteController.allowProfileSwitch, "invalid value for allow profile switch")
		XCTAssertTrue(concreteController.isExisting, "invalid value for is existing")
		XCTAssertEqual(concreteController.objectModel, objectModel!, "object model not correctly set")
		
		let controllerValidator = concreteController.profileValidation as PersonalProfileValidator
		
		XCTAssertEqual(controllerValidator, validator as PersonalProfileValidator, "incorrect validator set")
	}

	//test all positive paths
	//- check correct type is returned
	//- check that all params are set
	//test each version for negative paths
	//- missing params
}
