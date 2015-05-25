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
	
	func testInitThrowsOnNullObjectModel()
	{
		XCTAssertThrows({ () -> Void in
			let factory = PaymentFlowViewControllerFactory(objectModel: nil)
		}, "no exception on nil object model")
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
		
		let concreteController = controller as! PersonalPaymentProfileViewController
		
		XCTAssertTrue(concreteController.allowProfileSwitch, "invalid value for allow profile switch")
		XCTAssertTrue(concreteController.isExisting, "invalid value for is existing")
		XCTAssertEqual(concreteController.objectModel, objectModel!, "object model not correctly set")
		
		let controllerValidator = concreteController.profileValidation as! PersonalProfileValidator
		
		XCTAssertEqual(controllerValidator, validator as! PersonalProfileValidator, "incorrect personal validator set")
	}
	
	func testGetViewControllerReturnsCorrectRecipient()
	{
		let recipient: Recipient = Recipient.insertInManagedObjectContext(objectModel?.managedObjectContext) as! Recipient
		let validator: AnyObject! = validatorFactory!.getValidatorWithType(.ValidateRecipientProfile)
		let controller = factory!.getViewControllerWithType(.RecipientController, params: [kShowMiniProfile: true,
			kTemplateRecipient: recipient,
			kUpdateRecipient: recipient,
			kRecipientProfileValidator: validator,
			//so... a block (closure in Swift-speak) is not AnyObject .oO
			kNextActionBlock: unsafeBitCast(getEmptyBlock(), AnyObject.self)])
		
		XCTAssertNotNil(controller, "controller must exist")
		XCTAssertTrue(controller is RecipientViewController, "invalid type of controller")
		
		let concreteController = controller as! RecipientViewController
		
		XCTAssertTrue(concreteController.showMiniProfile, "invalid value for allow profile switch")
		XCTAssertEqual(concreteController.templateRecipient, recipient, "invalid template recipient set")
		XCTAssertEqual(concreteController.updateRecipient, recipient, "invalid update recipient set")
		//so... you can't compare closures in swift because they could be optimized differenlty
		XCTAssertNotNil(unsafeBitCast(concreteController.afterSaveAction, AnyObject.self), "after save action not set")
		
		let controllerValidator = concreteController.recipientValidation as! RecipientProfileValidator
		
		XCTAssertEqual(controllerValidator, validator as! RecipientProfileValidator, "incorrect recipient validator set")
	}
	
	func testGetViewControllerReturnsCorrectBusinessPaymentProfile()
	{
		let validator: AnyObject! = validatorFactory!.getValidatorWithType(.ValidateBusinessProfile)
		let controller = factory!.getViewControllerWithType(.BusinessPaymentProfileController, params: [kBusinessProfileValidator: validator])
		
		XCTAssertNotNil(controller, "controller must exist")
		XCTAssertTrue(controller is BusinessPaymentProfileViewController, "invalid type of controller")
		
		let concreteController = controller as! BusinessPaymentProfileViewController
		
		XCTAssertEqual(concreteController.objectModel, objectModel!, "object model not correctly set")
		
		let controllerValidator = concreteController.profileValidation as! BusinessProfileValidator
		
		XCTAssertEqual(controllerValidator, validator as! BusinessProfileValidator, "incorrect business profile validator set")
	}
	
	func testGetViewControllerReturnsCorrectConfirmPayment()
	{
		let controller = factory!.getViewControllerWithType(.ConfirmPaymentController, params: [kNextActionBlock: unsafeBitCast(getEmptyBlock(), AnyObject.self)])
		
		XCTAssertNotNil(controller, "controller must exist")
		XCTAssertTrue(controller is ConfirmPaymentViewController, "invalid type of controller")
		
		let concreteController = controller as! ConfirmPaymentViewController
		
		XCTAssertEqual(concreteController.objectModel, objectModel!, "object model not correctly set")
		XCTAssertNotNil(unsafeBitCast(concreteController.sucessBlock, AnyObject.self), "after save action not set")
		
	}
	
	func testGetViewControllerReturnsCorrectPersonalProfileIdentification()
	{
		let pendingPayment: PendingPayment = PendingPayment.insertInManagedObjectContext(objectModel?.managedObjectContext) as! PendingPayment
		pendingPayment.proposedPaymentsPurpose = "blah"
		let controller = factory!.getViewControllerWithType(.PersonalProfileIdentificationController, params: [kPendingPayment: pendingPayment,
			kVerificationCompletionBlock: unsafeBitCast(getEmptyBlock(), AnyObject.self)])
		
		XCTAssertNotNil(controller, "controller must exist")
		XCTAssertTrue(controller is PersonalProfileIdentificationViewController, "invalid type of controller")
		
		let concreteController = controller as! PersonalProfileIdentificationViewController
		
		XCTAssertEqual(concreteController.objectModel, objectModel!, "object model not correctly set")
		XCTAssertEqual(concreteController.identificationRequired, IdentificationRequired(rawValue: pendingPayment.verificiationNeededValue), "invalid verification needed set")
		XCTAssertEqual(concreteController.proposedPaymentPurpose, pendingPayment.proposedPaymentsPurpose, "invalid proposed payment purpose set")
		XCTAssertNotNil(unsafeBitCast(concreteController.completionHandler, AnyObject.self), "completion handler not set")
	}
	
	func testGetViewControllerReturnsCorrectPaymentMethodSelector()
	{
		let payment: Payment = Payment.insertInManagedObjectContext(objectModel?.managedObjectContext) as! Payment
		let controller = factory!.getViewControllerWithType(.PaymentMethodSelectorController, params: [kPayment: payment])
		
		XCTAssertNotNil(controller, "controller must exist")
		XCTAssertTrue(controller is PaymentMethodSelectorViewController, "invalid type of controller")
		
		let concreteController = controller as! PaymentMethodSelectorViewController
		
		XCTAssertEqual(concreteController.objectModel, objectModel!, "object model not correctly set")
		XCTAssertEqual(concreteController.payment, payment, "invalid payment set")
	}
	
	func testGetViewControllerReturnsCorrectUploadMoney()
	{
		let payment: Payment = Payment.insertInManagedObjectContext(objectModel?.managedObjectContext) as! Payment
		let controller = factory!.getViewControllerWithType(.UploadMoneyController, params: [kPayment: payment])
		
		XCTAssertNotNil(controller, "controller must exist")
		XCTAssertTrue(controller is UploadMoneyViewController, "invalid type of controller")
		
		let concreteController = controller as! UploadMoneyViewController
		
		XCTAssertEqual(concreteController.objectModel, objectModel!, "object model not correctly set")
		XCTAssertEqual(concreteController.payment, payment, "invalid payment set")
	}
	
	func testGetViewControllerReturnsCorrectBusinessProfileIdentification()
	{
		let pendingPayment: PendingPayment = PendingPayment.insertInManagedObjectContext(objectModel?.managedObjectContext) as! PendingPayment
		pendingPayment.proposedPaymentsPurpose = "blah"
		let controller = factory!.getViewControllerWithType(.BusinessProfileIdentificationController, params: [kPendingPayment: pendingPayment,
			kVerificationCompletionBlock: unsafeBitCast(getEmptyBlock(), AnyObject.self)])
		
		XCTAssertNotNil(controller, "controller must exist")
		XCTAssertTrue(controller is BusinessProfileIdentificationViewController, "invalid type of controller")
		
		let concreteController = controller as! BusinessProfileIdentificationViewController
		
		XCTAssertNotNil(unsafeBitCast(concreteController.completionHandler, AnyObject.self), "completion handler not set")
	}
	
	func testGetViewControllerReturnsCorrectRefundDetailsController()
	{
		let sourceCurrency: Currency = Currency.insertInManagedObjectContext(objectModel?.managedObjectContext) as! Currency
		let pendingPayment: PendingPayment = PendingPayment.insertInManagedObjectContext(objectModel?.managedObjectContext) as! PendingPayment
		pendingPayment.sourceCurrency = sourceCurrency
		let controller = factory!.getViewControllerWithType(.RefundDetailsController, params: [kPendingPayment: pendingPayment,
			kNextActionBlock: unsafeBitCast(getEmptyBlock(), AnyObject.self)])
		
		XCTAssertNotNil(controller, "controller must exist")
		XCTAssertTrue(controller is RefundDetailsViewController, "invalid type of controller")
		
		let concreteController = controller as! RefundDetailsViewController
		
		XCTAssertEqual(concreteController.objectModel, objectModel!, "object model not correctly set")
		XCTAssertEqual(concreteController.payment, pendingPayment, "invalid pending payment set")
		XCTAssertEqual(concreteController.currency, sourceCurrency, "invalid source currency set")
	}
    
    func testGetCustomModalReturnsCorrectNoPayInMethodsModal()
    {
        
        let sourceCurrency: Currency = Currency.insertInManagedObjectContext(objectModel?.managedObjectContext) as! Currency
        let pendingPayment: PendingPayment = PendingPayment.insertInManagedObjectContext(objectModel?.managedObjectContext) as! PendingPayment
        pendingPayment.sourceCurrency = sourceCurrency
        let controller = factory!.getCustomModalWithType(ModalType.NoPayInMethodsFailModal, params: [kPayment: pendingPayment])
        
        XCTAssertNotNil(controller, "controller must exist")
        XCTAssertTrue(controller is CustomInfoViewController, "invalid type of controller")
        
        let concreteController = controller as! CustomInfoViewController
        
        XCTAssertTrue(concreteController.mapCloseButtonToActionIndex == 0, "close action not correctly mapped")
        
        
        
        if (concreteController.actionButtonBlocks?.count == 1)
        {}
        else
        {
            XCTFail("action button block not set")
        }
        
    }
    

	//test each version for negative paths
	//- missing params
	
	func testGetViewControllerThrowsOnNullValidatorPersonalPayment()
	{
		XCTAssertThrows({ () -> Void in
			let controller = self.factory!.getViewControllerWithType(.PersonalPaymentProfileController, params: [kAllowProfileSwitch: true,
				kProfileIsExisting: true,
				kPersonalProfileValidator: NSNull()])
		}, "no exception on unset personal profile validator")
	}
	
	func testGetViewControllerThrowsOnNullValidatorRecipient()
	{
		XCTAssertThrows({ () -> Void in
			let controller = self.factory!.getViewControllerWithType(.RecipientController, params: [kShowMiniProfile: true,
				kTemplateRecipient: NSNull(),
				kUpdateRecipient: NSNull(),
				kRecipientProfileValidator: NSNull(),
				kNextActionBlock: unsafeBitCast(self.getEmptyBlock(), AnyObject.self)])
		}, "no exception on unset recipient profile validator")
	}
	
	func testGetViewControllerThrowsOnNullNextActionRecipient()
	{
		XCTAssertThrows({ () -> Void in
			let controller = self.factory!.getViewControllerWithType(.RecipientController, params: [kShowMiniProfile: true,
				kTemplateRecipient: NSNull(),
				kUpdateRecipient: NSNull(),
				kRecipientProfileValidator: self.validatorFactory!.getValidatorWithType(.ValidateRecipientProfile),
				kNextActionBlock: NSNull()])
		}, "no exception on unset recipient profile validator")
	}
	
	func testGetViewControllerThrowsOnNullValidatorBusinessPaymentProfile()
	{
		XCTAssertThrows({ () -> Void in
			let controller = self.factory!.getViewControllerWithType(.BusinessPaymentProfileController, params: [kBusinessProfileValidator: NSNull()])
		}, "no exception on unset business profile validator")
	}
	
	
	func testGetViewControllerThrowsOnNullNextActionConfirm()
	{
		XCTAssertThrows({ () -> Void in
			let controller = self.factory!.getViewControllerWithType(.ConfirmPaymentController, params: [kNextActionBlock: NSNull()])
		}, "no exception on unset next action block")
	}
	
	func testGetViewControllerThrowsOnNullPaymentPersonalIdentification()
	{
		XCTAssertThrows({ () -> Void in
			let controller = self.factory!.getViewControllerWithType(.PersonalProfileIdentificationController, params: [kPendingPayment: NSNull(),
				kVerificationCompletionBlock: unsafeBitCast(self.getEmptyBlock(), AnyObject.self)])
		}, "no exception on unset pending payment")
	}
	
	func testGetViewControllerThrowsOnNullVerificationCompletionPersonalIdentification()
	{
		XCTAssertThrows({ () -> Void in
			let pendingPayment: PendingPayment = PendingPayment.insertInManagedObjectContext(self.objectModel?.managedObjectContext) as! PendingPayment
			let controller = self.factory!.getViewControllerWithType(.PersonalProfileIdentificationController, params: [kPendingPayment: pendingPayment,
				kVerificationCompletionBlock: NSNull()])
		}, "no exception on unset verification completion")
	}
	
	func testGetViewControllerThrowsOnNullPaymentPaymentMethodSelector()
	{
		XCTAssertThrows({ () -> Void in
			let controller = self.factory!.getViewControllerWithType(.PaymentMethodSelectorController, params: [kPayment: NSNull()])
		}, "no exception on unset payment")
	}
	
	func testGetViewControllerThrowsOnNullPaymentUploadMoney()
	{
		XCTAssertThrows({ () -> Void in
			let controller = self.factory!.getViewControllerWithType(.UploadMoneyController, params: [kPayment: NSNull()])
		}, "no exception on unset payment")
	}
	
	func testGetViewControllerThrowsOnNullPaymentBusinessIdentification()
	{
		XCTAssertThrows({ () -> Void in
			let controller = self.factory!.getViewControllerWithType(.BusinessProfileIdentificationController, params: [kPendingPayment: NSNull(),
				kVerificationCompletionBlock: unsafeBitCast(self.getEmptyBlock(), AnyObject.self)])
		}, "no exception on unset payment")
	}
	
	func testGetViewControllerThrowsOnNullVerificationCompletionBusinessIdentification()
	{
		XCTAssertThrows({ () -> Void in
			let pendingPayment: PendingPayment = PendingPayment.insertInManagedObjectContext(self.objectModel?.managedObjectContext) as! PendingPayment
			let controller = self.factory!.getViewControllerWithType(.BusinessProfileIdentificationController, params: [kPendingPayment: pendingPayment,
				kVerificationCompletionBlock: NSNull()])
		}, "no exception on unset verification completion")
	}
	
	func testGetViewControllerThrowsOnNullPaymentRefund()
	{
		XCTAssertThrows({ () -> Void in
			let controller = self.factory!.getViewControllerWithType(.RefundDetailsController, params: [kPendingPayment: NSNull(),
				kNextActionBlock: unsafeBitCast(self.getEmptyBlock(), AnyObject.self)])
		}, "no exception on unset payment")
	}
	
	func testGetViewControllerThrowsOnNullNextActionRefund()
	{
		XCTAssertThrows({ () -> Void in
			let pendingPayment: PendingPayment = PendingPayment.insertInManagedObjectContext(self.objectModel?.managedObjectContext) as! PendingPayment
			let controller = self.factory!.getViewControllerWithType(.RefundDetailsController, params: [kPendingPayment: pendingPayment,
				kNextActionBlock: NSNull()])
		}, "no exception on unset next action block")
	}
    
    func testGetModalThrowsOnNullPayment()
    {
        XCTAssertThrows({ () -> Void in
            let controller = self.factory!.getCustomModalWithType(ModalType.NoPayInMethodsFailModal, params: [kPayment : NSNull()])
            }, "no exception on missing payment")
    }

    func testGetModalThrowsOnMissingParameters()
    {
        XCTAssertThrows({ () -> Void in
            let controller = self.factory!.getCustomModalWithType(ModalType.NoPayInMethodsFailModal, params: nil)
            }, "no exception on missing payment")
    }
    
	private func getEmptyBlock() -> TRWActionBlock
	{
		return {}
	}
    
}
