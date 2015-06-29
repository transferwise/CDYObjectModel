//
//  BusinessProfileTests.swift
//  Transfer
//
//  Created by Nick Banks on 29/06/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

import UIKit
import XCTest

// Set up some default constants for use in testing
extension BusinessProfile {

    // It would have been more pleasant to create a set of derived Mock classes, but this is not easily possible
    // with NSManagedObjects
    func setupAsGBR () {
        addressFirstLine = "186-188 City Road"
        businessDescription = "Software Development"
        city = "London"
        companyRole = "Company Director"
        companyType = "Company Limited By Guarantee"
        countryCode = "GBR"
        name = "Dave Spart"
        postCode = "EC1V 2NT"
        registrationNumber = "07209813"
    }
    
    func setupAsUSA () {
        addressFirstLine = "1708 Oakland Road, Suite 500"
        businessDescription = "Software Development"
        city = "San Jose"
        companyRole = "Company Director"
        companyType = "Company Limited By Guarantee"
        countryCode = "USA"
        name = "Dave Spart"
        postCode = "95131"
        registrationNumber = "07209813"
        state = "California"
    }
    
    func setupAsAUS () {
        abn = "121181976"
        acn = "0123454321"
        addressFirstLine = " 50 Hunter St,"
        arbn = ""
        businessDescription = "Software Development"
        city = "Sydney"
        companyRole = "Company Director"
        companyType = "Company Limited By Guarantee"
        countryCode = "AUS"
        name = "Dave Spart"
        postCode = "2000"
        registrationNumber = "07209813"
    }
}

class BusinessProfileTests: XCTestCase {
    
    let objectModel = ObjectModel();

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        // Clear out any objects we might have added to our MOC (we haven't saved so don't need to cycle through the objects)
        objectModel.managedObjectContext.reset()
    }

    /**
    Check to see if the mimimal set of fields is detected correctly for non-USA/UAS countries
    */
    func testGBRIsFilled() {
        // Create a profile
        var gbrBusinessProfile = BusinessProfile.insertInManagedObjectContext(objectModel.managedObjectContext) as! BusinessProfile
        
        // Check to see if actually created
        XCTAssertNotNil(gbrBusinessProfile, "Couldn't create business profile")
        
        // Initialise it with UK specific data, and see if it is reported as filled correctly (for GBR)
        gbrBusinessProfile.setupAsGBR()
        XCTAssertTrue(gbrBusinessProfile.isFilled(), "GBR Profile not completly filled")
        
        // Nil out one of the attributes that are required, and see if it is now reported as not filled
        gbrBusinessProfile.city = nil
        XCTAssertFalse(gbrBusinessProfile.isFilled(), "GBR Profile incorrectly reported as filled")
    }
    
    /**
    Check to see if all USA specific fields are detected
    */
    func testUSAIsFilled() {
        // Create a profile
        var usaBusinessProfile = BusinessProfile.insertInManagedObjectContext(objectModel.managedObjectContext) as! BusinessProfile
        
        // Check to see if actually created
        XCTAssertNotNil(usaBusinessProfile, "Couldn't create business profile")
        
        // Initialise it with UK specific data, and see if it is reported as filled correctly (for GBR)
        usaBusinessProfile.setupAsUSA()
        XCTAssertTrue(usaBusinessProfile.isFilled(), "USA Profile not completly filled")
        
        // Nil out one of the attributes that are required, and see if it is now reported as not filled
        usaBusinessProfile.city = nil
        XCTAssertFalse(usaBusinessProfile.isFilled(), "USA Profile incorrectly reported as filled")
    }
    
    /**
    Check to see if all AUS specific fields are detected
    */
    func testAUSIsFilled() {
        // Create a profile
        var ausBusinessProfile = BusinessProfile.insertInManagedObjectContext(objectModel.managedObjectContext) as! BusinessProfile
        
        // Check to see if actually created
        XCTAssertNotNil(ausBusinessProfile, "Couldn't create business profile")
        
        // Initialise it with UK specific data, and see if it is reported as filled correctly (for GBR)
        ausBusinessProfile.setupAsAUS()
        XCTAssertTrue(ausBusinessProfile.isFilled(), "AUS Profile not completly filled")
        
        // Nil out one of the attributes that are required, and see if it is now reported as not filled
        ausBusinessProfile.city = nil
        XCTAssertFalse(ausBusinessProfile.isFilled(), "AUS Profile incorrectly reported as filled")
    }
}
