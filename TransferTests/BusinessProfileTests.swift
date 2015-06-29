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
    
    class MockBusinessProfile: BusinessProfile {

        override func awakeFromInsert() {
            super.awakeFromInsert()
            
            abn = ""
            acn = ""
            addressFirstLine = ""
            arbn = ""
            businessDescription = ""
            city = ""
            companyRole = ""
            companyType = ""
            countryCode = ""
            name = ""
            postCode = ""
            readonlyFields = ""
            registrationNumber = ""
            state = ""
        }
    }

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testIsFilled() {

    }
}
