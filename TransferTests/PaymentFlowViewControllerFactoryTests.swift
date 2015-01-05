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
	
	//test all positive paths
	//- check correct type is returned
	//- check that all params are set
	
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
	
	func testGetViewControllerReturnsCorrectRecipient()
	{
		let recipient: Recipient = Recipient.insertInManagedObjectContext(objectModel?.managedObjectContext) as Recipient
		let validator: AnyObject! = validatorFactory!.getValidatorWithType(.ValidateRecipientProfile)
		let block: TRWActionBlock = {}
		let controller = factory!.getViewControllerWithType(.RecipientController, params: [kShowMiniProfile: true,
			kTemplateRecipient: recipient,
			kUpdateRecipient: recipient,
			kRecipientProfileValidator: validator,
			//so... a block (closure in Swift-speak) is not AnyObject .oO
			kNextActionBlock: unsafeBitCast(block, AnyObject.self)])
		
		XCTAssertNotNil(controller, "controller must exist")
		XCTAssertTrue(controller is RecipientViewController, "invalid type of controller")
		
		let concreteController = controller as RecipientViewController
		
		XCTAssertTrue(concreteController.showMiniProfile, "invalid value for allow profile switch")
		XCTAssertEqual(concreteController.templateRecipient, recipient, "invalid template recipient set")
		XCTAssertEqual(concreteController.updateRecipient, recipient, "invalid update recipient set")
		//so... you can't compare closures in swift because they could be optimized differenlty
		XCTAssertNotNil(unsafeBitCast(concreteController.afterSaveAction, AnyObject.self), "after save action not set")
		
		let controllerValidator = concreteController.recipientValidation as RecipientProfileValidator
		
		XCTAssertEqual(controllerValidator, validator as RecipientProfileValidator, "incorrect validator set")
	}

	//test each version for negative paths
	//- missing params
}
