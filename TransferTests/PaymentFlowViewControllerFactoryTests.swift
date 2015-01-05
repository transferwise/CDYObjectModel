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
		
		XCTAssertEqual(controllerValidator, validator as PersonalProfileValidator, "incorrect personal validator set")
	}
	
	func testGetViewControllerReturnsCorrectRecipient()
	{
		let recipient: Recipient = Recipient.insertInManagedObjectContext(objectModel?.managedObjectContext) as Recipient
		let validator: AnyObject! = validatorFactory!.getValidatorWithType(.ValidateRecipientProfile)
		let controller = factory!.getViewControllerWithType(.RecipientController, params: [kShowMiniProfile: true,
			kTemplateRecipient: recipient,
			kUpdateRecipient: recipient,
			kRecipientProfileValidator: validator,
			//so... a block (closure in Swift-speak) is not AnyObject .oO
			kNextActionBlock: unsafeBitCast(getEmptyBlock(), AnyObject.self)])
		
		XCTAssertNotNil(controller, "controller must exist")
		XCTAssertTrue(controller is RecipientViewController, "invalid type of controller")
		
		let concreteController = controller as RecipientViewController
		
		XCTAssertTrue(concreteController.showMiniProfile, "invalid value for allow profile switch")
		XCTAssertEqual(concreteController.templateRecipient, recipient, "invalid template recipient set")
		XCTAssertEqual(concreteController.updateRecipient, recipient, "invalid update recipient set")
		//so... you can't compare closures in swift because they could be optimized differenlty
		XCTAssertNotNil(unsafeBitCast(concreteController.afterSaveAction, AnyObject.self), "after save action not set")
		
		let controllerValidator = concreteController.recipientValidation as RecipientProfileValidator
		
		XCTAssertEqual(controllerValidator, validator as RecipientProfileValidator, "incorrect recipient validator set")
	}
	
	func testGetViewControllerReturnsCorrectBusinessPaymentProfile()
	{
		let validator: AnyObject! = validatorFactory!.getValidatorWithType(.ValidateBusinessProfile)
		let controller = factory!.getViewControllerWithType(.BusinessPaymentProfileController, params: [kBusinessProfileValidator: validator])
		
		XCTAssertNotNil(controller, "controller must exist")
		XCTAssertTrue(controller is BusinessPaymentProfileViewController, "invalid type of controller")
		
		let concreteController = controller as BusinessPaymentProfileViewController
		
		XCTAssertEqual(concreteController.objectModel, objectModel!, "object model not correctly set")
		
		let controllerValidator = concreteController.profileValidation as BusinessProfileValidator
		
		XCTAssertEqual(controllerValidator, validator as BusinessProfileValidator, "incorrect business profile validator set")
	}
	
	func testGetViewControllerReturnsCorrectConfirmPayment()
	{
		let validator: AnyObject! = validatorFactory!.getValidatorWithType(.ValidatePayment)
		let controller = factory!.getViewControllerWithType(.ConfirmPaymentController, params: [kPaymentValidator: validator,
			kNextActionBlock: unsafeBitCast(getEmptyBlock(), AnyObject.self)])
		
		XCTAssertNotNil(controller, "controller must exist")
		XCTAssertTrue(controller is ConfirmPaymentViewController, "invalid type of controller")
		
		let concreteController = controller as ConfirmPaymentViewController
		
		XCTAssertEqual(concreteController.objectModel, objectModel!, "object model not correctly set")
		XCTAssertNotNil(unsafeBitCast(concreteController.sucessBlock, AnyObject.self), "after save action not set")
		
		let controllerValidator = concreteController.paymentValidator as PaymentValidator
		
		XCTAssertEqual(controllerValidator, validator as PaymentValidator, "incorrect business profile validator set")
	}
	
	func testGetViewControllerReturnsCorrectPersonalProfileIdentification()
	{
		let pendingPayment: PendingPayment = PendingPayment.insertInManagedObjectContext(objectModel?.managedObjectContext) as PendingPayment
		pendingPayment.proposedPaymentsPurpose = "blah"
		let controller = factory!.getViewControllerWithType(.PersonalProfileIdentificationController, params: [kPendingPayment: pendingPayment])
		
		XCTAssertNotNil(controller, "controller must exist")
		XCTAssertTrue(controller is PersonalProfileIdentificationViewController, "invalid type of controller")
		
		let concreteController = controller as PersonalProfileIdentificationViewController
		
		XCTAssertEqual(concreteController.objectModel, objectModel!, "object model not correctly set")
		XCTAssertEqual(concreteController.identificationRequired, IdentificationRequired(rawValue: pendingPayment.verificiationNeededValue), "invalid verification needed set")
		XCTAssertEqual(concreteController.proposedPaymentPurpose, pendingPayment.proposedPaymentsPurpose, "invalid proposed payment purpose set")
	}

	//test each version for negative paths
	//- missing params
	
	private func getEmptyBlock() -> TRWActionBlock
	{
		return {}
	}
}
