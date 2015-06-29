//
//  BusinessProfileTests.swift
//  Transfer
//
//  Created by Nick Banks on 29/06/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

import UIKit
import XCTest

class BusinessProfileTests: XCTestCase {
    
    let objectModel = ObjectModel();
    
    // Set up some default constants for use in testing
    class MockUSABusinessProfile : BusinessProfile {
        
        override func awakeFromInsert() {
            super.awakeFromInsert()
            
            addressFirstLine = "1708 Oakland Road, Suite 500"
            businessDescription = ""
            city = "San Jose"
            companyRole = ""
            companyType = ""
            countryCode = "USA"
            name = "Dave Spart"
            postCode = "95131"
            registrationNumber = "07209813"
            state = "California"
        }
    }
    
    class MockAUSBusinessProfile : BusinessProfile {
        
        override func awakeFromInsert() {
            super.awakeFromInsert()
            
            abn = "121181976"
            acn = "0123454321"
            addressFirstLine = " 50 Hunter St,"
            arbn = ""
            businessDescription = ""
            city = "Sydney"
            companyRole = ""
            companyType = ""
            countryCode = "AUS"
            name = "Dave Spart"
            postCode = "2000"
            registrationNumber = "07209813"
        }
    }
    
    class MockGBRBusinessProfile : BusinessProfile {
        
        override func awakeFromInsert() {
            super.awakeFromInsert()
            
            addressFirstLine = "186-188 City Road"
            businessDescription = "x"
            city = "London"
            companyRole = "x"
            companyType = "x"
            countryCode = "GBR"
            name = "Dave Spart"
            postCode = "EC1V 2NT"
            registrationNumber = "07209813"
        }
    }

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

    func testGBRIsFilled() {
        
        var gbrBusinessProfile = MockGBRBusinessProfile.insertInManagedObjectContext(objectModel.managedObjectContext)
        
        XCTAssertNotNil(gbrBusinessProfile, "Couldn't create business profile")
        XCTAssertTrue(gbrBusinessProfile.isFilled(), "GBR Profile not completly filled")
        
//        gbrBusinessProfile.city = ""
        
        XCTAssertFalse(gbrBusinessProfile.isFilled(), "GBR Profile incorrectly reported as filled")
    }
}
