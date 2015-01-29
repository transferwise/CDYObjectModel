//
//  CalculationResultTests.swift
//  Transfer
//
//  Created by Mats Trovik on 29/01/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

import UIKit
import XCTest
import Foundation

class CalculationResultTests: XCTestCase
{
    func testIsZeroFeeWithFloat()
    {
        let floatFee :Float = 0.0
        let calculationResult = CalculationResult(data:["transferwiseTransferFee":floatFee])
        
        XCTAssertTrue(calculationResult.isFeeZero(), "Float 0.0f is not considered zero!!")
    }
    func testIsZeroFeeWithFloat2()
    {
        let floatFee :Float = (1.0/11.0) * (10.9 + 0.1) - 1
        let calculationResult = CalculationResult(data:["transferwiseTransferFee":floatFee])
        
        XCTAssertTrue(calculationResult.isFeeZero(), "Float 0.0f is not considered zero!!")
    }
    
    func testIsZeroFeeWithFloat3()
    {
        let floatFee :Float = -0.0
        let calculationResult = CalculationResult(data:["transferwiseTransferFee":floatFee])
        
        XCTAssertTrue(calculationResult.isFeeZero(), "Float 0.0f is not considered zero!!")
    }
    
    func testIsNotZeroFeeWithFloat()
    {
        var floatFee :Float = 1.0
        let calculationResult = CalculationResult(data:["transferwiseTransferFee":floatFee])
        XCTAssertFalse(calculationResult.isFeeZero(), "Float 1.0f is considered zero!!")
    }
    
    func testIsNotZeroFeeWithFloat2()
    {
        var floatFee :Float = 1.0/0.0
        let calculationResult = CalculationResult(data:["transferwiseTransferFee":floatFee])
        XCTAssertFalse(calculationResult.isFeeZero(), "Float 1.0f is considered zero!!")
    }
    
    func testIsNotZeroFeeWithFloat3()
    {
        var floatFee :Float = Float.infinity
        let calculationResult = CalculationResult(data:["transferwiseTransferFee":floatFee])
        XCTAssertFalse(calculationResult.isFeeZero(), "Float 1.0f is considered zero!!")
    }
    
    func testIsNotZeroFeeWithFloat4()
    {
        var floatFee :Float = Float.NaN
        let calculationResult = CalculationResult(data:["transferwiseTransferFee":floatFee])
        XCTAssertFalse(calculationResult.isFeeZero(), "Float 1.0f is considered zero!!")
    }
    
    func testIsNotZeroFeeWithFloat5()
    {
        var floatFee :Float = Float.quietNaN
        let calculationResult = CalculationResult(data:["transferwiseTransferFee":floatFee])
        XCTAssertFalse(calculationResult.isFeeZero(), "Float 1.0f is considered zero!!")
    }
    
    func testIsNotZeroFeeWithFloat6()
    {
        var floatFee :Float = Float.infinity + 1
        let calculationResult = CalculationResult(data:["transferwiseTransferFee":floatFee])
        XCTAssertFalse(calculationResult.isFeeZero(), "Float 1.0f is considered zero!!")
    }
    
    
    func testIsZeroFeeWithInt()
    {
        let floatFee :Int = 0
        let calculationResult = CalculationResult(data:["transferwiseTransferFee":floatFee])
        
        XCTAssertTrue(calculationResult.isFeeZero(), "Float 0.0f is not considered zero!!")
    }
    func testIsZeroFeeWithInt2()
    {
        let floatFee :Int = 1-1
        let calculationResult = CalculationResult(data:["transferwiseTransferFee":floatFee])
        
        XCTAssertTrue(calculationResult.isFeeZero(), "Float 0.0f is not considered zero!!")
    }
    
    func testIsNotZeroFeeWithInt()
    {
        var floatFee :Float = 1
        let calculationResult = CalculationResult(data:["transferwiseTransferFee":floatFee])
        XCTAssertFalse(calculationResult.isFeeZero(), "Float 1.0f is considered zero!!")
    }

    func testIsZeroFeeWithDouble()
    {
        let floatFee :Double = 0
        let calculationResult = CalculationResult(data:["transferwiseTransferFee":floatFee])
        
        XCTAssertTrue(calculationResult.isFeeZero(), "Float 0.0f is not considered zero!!")
    }
    func testIsZeroFeeWithDouble2()
    {
        let floatFee :Double = (1.0/11.0) * (10.9 + 0.1) - 1
        let calculationResult = CalculationResult(data:["transferwiseTransferFee":floatFee])
        
        XCTAssertTrue(calculationResult.isFeeZero(), "Float 0.0f is not considered zero!!")
    }
    
    func testIsNotZeroFeeWithDouble()
    {
        var floatFee :Double = 1.0
        let calculationResult = CalculationResult(data:["transferwiseTransferFee":floatFee])
        XCTAssertFalse(calculationResult.isFeeZero(), "Float 1.0f is considered zero!!")
    }

    
}