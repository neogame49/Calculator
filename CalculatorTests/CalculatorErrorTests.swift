//
//  CalculatorErrorTests.swift
//  CalculatorOnSwift
//
//  Created by Macbook on 19.02.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

import Foundation
import XCTest
import Calculator


class CalculatorTestsErrorCases: XCTestCase, CalculatorDataSource, CalculatorDelegate
{
    var calculator: Calculator!
    
    //MARK:- CalculatorDataSource
    var constVariables: [String: NSDecimalNumber]
        {
            return ["Pi": NSDecimalNumber(string: "3.14"), "exp": NSDecimalNumber(string: "2.7")]
    }
    var functions: [String]
        {
            return ["sin","cos","max","min"]
    }
    
    // MARK:- CalculatorDelegate
    func computForCalculator(calculator: Calculator, function: String, params: [NSDecimalNumber],
        handleError: ((NSError) -> Void)?) -> NSDecimalNumber?
    {
        switch(function)
        {
        case "sin":
            if params.count != 1
            {
                let error = NSError(domain: "wrong number of argument for sin function", code: 20000, userInfo: nil)
                handleError?(error)
                return nil
            }
            return NSDecimalNumber(double: sin(params.first!.doubleValue))
        case "cos":
            if params.count != 1
            {
                let error = NSError(domain: "wrong number of argument for cos function", code: 20000, userInfo: nil)
                handleError?(error)
                return nil
            }
            return NSDecimalNumber(double: cos(params.first!.doubleValue))
        case "max":
            if params.count != 2
            {
                let error = NSError(domain: "wrong number of argument for max function", code: 20000, userInfo: nil)
                handleError?(error)
                return nil
            }
            return NSDecimalNumber(double: max(params[0].doubleValue, params[1].doubleValue))
        case "min":
            if params.count != 2
            {
                let error = NSError(domain: "wrong number of argument for min function", code: 20000, userInfo: nil)
                handleError?(error)
                return nil
            }
            return NSDecimalNumber(double: min(params[0].doubleValue, params[1].doubleValue))
        default:
            let error = NSError(domain: "unknown \(function) function", code: 20000, userInfo: nil)
            handleError?(error)
            return nil
        }
        
    }
    
    override func setUp()
    {
        super.setUp()
        
        calculator = Calculator(expression: "")
        
        calculator.dataSource = self
        calculator.delegate = self
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testErrorNumberFormarCase()
    {
        calculator.expression = "2.2.2+2..2"
        
        let result = calculator.eval()
        
        XCTAssertNil(result.result, "not nil result in ErrorNumberFormarCase")
        XCTAssertNotNil(result.error, "nil error in ErrorNumberFormarCase")
        XCTAssertNotNil(result.error!.userInfo, "nil error userInfo in ErrorNumberFormarCase")
        
        let rangeOfErrorPart = result.error?.userInfo?[Calculator.PublicConstants.RangeOfErrorPartExpression] as? NSRange
        
        XCTAssertNotNil(rangeOfErrorPart, "nil error userInfo rangeOfErrorPart in ErrorNumberFormarCase")
        XCTAssert( NSEqualRanges(rangeOfErrorPart!, NSMakeRange(0, 5)),
            "uncorrect rangeOfErrorPart in ErrorNumberFormarCase")
        
        println(result.error!.domain)
        
    }
    func testErrorMissingCloseBracket()
    {
        calculator.expression = "2+(2+2"
        
        let result = calculator.eval()
        
        XCTAssertNil(result.result, "not nil result in ErrorMissingCloseBracket")
        XCTAssertNotNil(result.error, "nil error in ErrorMissingCloseBracket")
        XCTAssertNotNil(result.error!.userInfo, "nil error userInfo in ErrorMissingCloseBracket")
        
        let rangeOfErrorPart = result.error?.userInfo?[Calculator.PublicConstants.RangeOfErrorPartExpression] as? NSRange
        
        XCTAssertNotNil(rangeOfErrorPart, "nil error userInfo rangeOfErrorPart in ErrorMissingCloseBracket")
        XCTAssert( NSEqualRanges(rangeOfErrorPart!, NSMakeRange(2, 1)),
            "uncorrect rangeOfErrorPart in ErrorMissingCloseBracket")
        
        println(result.error!.domain)
        
    }
    func testErrorMissingOpenBracket()
    {
        calculator.expression = "2+2+2)"
        
        let result = calculator.eval()
        
        XCTAssertNil(result.result, "not nil result in ErrorMissingOpenBracket")
        XCTAssertNotNil(result.error, "nil error in ErrorMissingOpenBracket")
        XCTAssertNotNil(result.error!.userInfo, "nil error userInfo in ErrorMissingOpenBracket")
        
        let rangeOfErrorPart = result.error?.userInfo?[Calculator.PublicConstants.RangeOfErrorPartExpression] as? NSRange
        
        XCTAssertNotNil(rangeOfErrorPart, "nil error userInfo rangeOfErrorPart in ErrorMissingOpenBracket")
        XCTAssert( NSEqualRanges(rangeOfErrorPart!, NSMakeRange(5, 1)),
            "uncorrect rangeOfErrorPart in ErrorMissingOpenBracket")
        
        println(result.error!.domain)
        
    }
    func testErrorTryToUseUndefineVariables()
    {
        calculator.expression = "2 - undefVar1 + undefVar2"
        
        let result = calculator.eval()
        
        XCTAssertNil(result.result, "not nil result in ErrorTryToUseUndefineVariables")
        XCTAssertNotNil(result.error, "nil error in ErrorTryToUseUndefineVariables")
        XCTAssertNotNil(result.error!.userInfo, "nil error userInfo in ErrorTryToUseUndefineVariables")
        
        let rangeOfErrorPart = result.error?.userInfo?[Calculator.PublicConstants.RangeOfErrorPartExpression] as? NSRange
        
        XCTAssertNotNil(rangeOfErrorPart, "nil error userInfo rangeOfErrorPart in ErrorTryToUseUndefineVariables")
        XCTAssert( NSEqualRanges(rangeOfErrorPart!, NSMakeRange(4, 9)),
            "uncorrect rangeOfErrorPart in ErrorTryToUseUndefineVariables")
        
        
        println(result.error!.domain)
        
    }
    func testErrorTryToComputedUndefineFunction()
    {
        calculator.expression = "undefFunc(2)"
        
        let result = calculator.eval()
        
        XCTAssertNil(result.result, "not nil result in ErrorTryToComputedUndefineFunction")
        XCTAssertNotNil(result.error, "nil error in ErrorTryToComputedUndefineFunction")
        XCTAssertNotNil(result.error!.userInfo, "nil error userInfo in ErrorTryToComputedUndefineFunction")
        
        let rangeOfErrorPart = result.error?.userInfo?[Calculator.PublicConstants.RangeOfErrorPartExpression] as? NSRange
        
        XCTAssertNotNil(rangeOfErrorPart, "nil error userInfo rangeOfErrorPart in ErrorTryToComputedUndefineFunction")
        XCTAssert( NSEqualRanges(rangeOfErrorPart!, NSMakeRange(0, 9)),
            "uncorrect rangeOfErrorPart in ErrorTryToComputedUndefineFunction")
        
        
        println(result.error!.domain)
        
    }
    func testErrorExpresionWithUndefineSumbols()
    {
        calculator.expression = "2?2@5"
        
        let result = calculator.eval()
        
        XCTAssertNil(result.result, "not nil result in ErrorExpresionWithUndefineSumbols")
        XCTAssertNotNil(result.error, "nil error in ErrorExpresionWithUndefineSumbols")
        XCTAssertNotNil(result.error!.userInfo, "nil error userInfo in ErrorExpresionWithUndefineSumbols")
        
        let rangeOfErrorPart = result.error?.userInfo?[Calculator.PublicConstants.RangeOfErrorPartExpression] as? NSRange
        
        XCTAssertNotNil(rangeOfErrorPart, "nil error userInfo rangeOfErrorPart in ErrorExpresionWithUndefineSumbols")
        XCTAssert( NSEqualRanges(rangeOfErrorPart!, NSMakeRange(1, 1)),
            "uncorrect rangeOfErrorPart in ErrorExpresionWithUndefineSumbols")
        
        
        println(result.error!.domain)
        
    }
    
    func testErrorToMuchUnaryOperators()
    {
        calculator.expression = "2+ --3+ +++4"
        
        let result = calculator.eval()
        
        XCTAssertNil(result.result, "not nil result in ErrorToMuchUnaryOperators")
        XCTAssertNotNil(result.error, "nil error in ErrorToMuchUnaryOperators")
        XCTAssertNotNil(result.error!.userInfo, "nil error userInfo in ErrorToMuchUnaryOperators")
        
        let rangeOfErrorPart = result.error?.userInfo?[Calculator.PublicConstants.RangeOfErrorPartExpression] as? NSRange
        
        XCTAssertNotNil(rangeOfErrorPart, "nil error userInfo rangeOfErrorPart in ErrorToMuchUnaryOperators")
        XCTAssert( NSEqualRanges(rangeOfErrorPart!, NSMakeRange(4, 1)),
            "uncorrect rangeOfErrorPart in ErrorToMuchUnaryOperators")
        
        
        println(result.error!.domain)
        
    }
    func testErrorDivByZero()
    {
        calculator.expression = "2/(2-2)"
        
        let result = calculator.eval()
        
        XCTAssertNil(result.result, "not nil result in ErrorDivByZero")
        XCTAssertNotNil(result.error, "nil error in ErrorDivByZero")
        XCTAssertNotNil(result.error!.userInfo, "nil error userInfo in ErrorDivByZero")
        
        let rangeOfErrorPart = result.error?.userInfo?[Calculator.PublicConstants.RangeOfErrorPartExpression] as? NSRange
        
        XCTAssertNotNil(rangeOfErrorPart, "nil error userInfo rangeOfErrorPart in ErrorDivByZero")
        XCTAssert( NSEqualRanges(rangeOfErrorPart!, NSMakeRange(1, 1)),
            "uncorrect rangeOfErrorPart in ErrorDivByZero")
        
        
        println(result.error!.domain)
        
    }
    func testMissingSecondOperand()
    {
        calculator.expression = "2^2^"
        
        let result = calculator.eval()
        
        XCTAssertNil(result.result, "not nil result in MissingSecondOperand")
        XCTAssertNotNil(result.error, "nil error in MissingSecondOperand")
        XCTAssertNotNil(result.error!.userInfo, "nil error userInfo in MissingSecondOperand")
        
        let rangeOfErrorPart = result.error?.userInfo?[Calculator.PublicConstants.RangeOfErrorPartExpression] as? NSRange
        
        XCTAssertNotNil(rangeOfErrorPart, "nil error userInfo rangeOfErrorPart in MissingSecondOperand")
        XCTAssert( NSEqualRanges(rangeOfErrorPart!, NSMakeRange(3, 1)),
            "uncorrect rangeOfErrorPart in MissingSecondOperand")
        
        
        println(result.error!.domain)
        
    }
    
    func testErrorCommaOutsideOfFunction()
    {
        calculator.expression = "max(2,Pi),"
        
        let result = calculator.eval()
        
        XCTAssertNil(result.result, "not nil result in ErrorCommaOutsideOfFunction")
        XCTAssertNotNil(result.error, "nil error in ErrorCommaOutsideOfFunction")
        XCTAssertNotNil(result.error!.userInfo, "nil error userInfo in ErrorCommaOutsideOfFunction")
        
        let rangeOfErrorPart = result.error?.userInfo?[Calculator.PublicConstants.RangeOfErrorPartExpression] as? NSRange
        
        XCTAssertNotNil(rangeOfErrorPart, "nil error userInfo rangeOfErrorPart in ErrorCommaOutsideOfFunction")
        XCTAssert( NSEqualRanges(rangeOfErrorPart!, NSMakeRange(9, 1)),
            "uncorrect rangeOfErrorPart in ErrorCommaOutsideOfFunction")
        
        
        println(result.error!.domain)
        
    }
    func testErrorMissingArgumentIntoFunction()
    {
        calculator.expression = "max(2,)"
        
        let result = calculator.eval()
        
        XCTAssertNil(result.result, "not nil result in MissingArgumentIntoFunction")
        XCTAssertNotNil(result.error, "nil error in MissingArgumentIntoFunction")
        XCTAssertNotNil(result.error!.userInfo, "nil error userInfo in MissingArgumentIntoFunction")
        
        let rangeOfErrorPart = result.error?.userInfo?[Calculator.PublicConstants.RangeOfErrorPartExpression] as? NSRange
        
        XCTAssertNotNil(rangeOfErrorPart, "nil error userInfo rangeOfErrorPart in MissingArgumentIntoFunction")
        XCTAssert( NSEqualRanges(rangeOfErrorPart!, NSMakeRange(0, 3)),
            "uncorrect rangeOfErrorPart in MissingArgumentIntoFunction")
        
        
        println(result.error!.domain)
        
    }
    
    func testErrorTryAssignedValueToConstant()
    {
        calculator.expression = "Pi=5"
        
        let result = calculator.eval()
        
        XCTAssertNil(result.result, "not nil result in ErrorTryAssignedValueToConstant")
        XCTAssertNotNil(result.error, "nil error in ErrorTryAssignedValueToConstant")
        XCTAssertNotNil(result.error!.userInfo, "nil error userInfo in ErrorTryAssignedValueToConstant")
        
        let rangeOfErrorPart = result.error?.userInfo?[Calculator.PublicConstants.RangeOfErrorPartExpression] as? NSRange
        
        XCTAssertNotNil(rangeOfErrorPart, "nil error userInfo rangeOfErrorPart in ErrorTryAssignedValueToConstant")
        XCTAssert( NSEqualRanges(rangeOfErrorPart!, NSMakeRange(2, 1)),
            "uncorrect rangeOfErrorPart in ErrorTryAssignedValueToConstant")
        
        
        println(result.error!.domain)
        
    }
    
    func testErrorNotPrefixUnaryDelimiterToAForwardExpresion()
    {
        calculator.expression = "!3*4"
        
        let result = calculator.eval()
        
        XCTAssertNil(result.result, "not nil result in ErrorNotPrefixUnaryDelimiterToAForwardExpresion")
        XCTAssertNotNil(result.error, "nil error in ErrorNotPrefixUnaryDelimiterToAForwardExpresion")
        XCTAssertNotNil(result.error!.userInfo, "nil error userInfo in ErrorNotPrefixUnaryDelimiterToAForwardExpresion")
        
        let rangeOfErrorPart = result.error?.userInfo?[Calculator.PublicConstants.RangeOfErrorPartExpression] as? NSRange
        
        XCTAssertNotNil(rangeOfErrorPart, "nil error userInfo rangeOfErrorPart in ErrorNotPrefixUnaryDelimiterToAForwardExpresion")
        XCTAssert( NSEqualRanges(rangeOfErrorPart!, NSMakeRange(0, 1)),
            "uncorrect rangeOfErrorPart in ErrorNotPrefixUnaryDelimiterToAForwardExpresion")
        
        
        println(result.error!.domain)
        
    }
    
    func testErrorTryComputeFactorialFromNegativeNumber()
    {
        calculator.expression = "-5!"
        
        let result = calculator.eval()
        
        XCTAssertNil(result.result, "not nil result in ErrorTryComputeFactorialFromNegativeNumber")
        XCTAssertNotNil(result.error, "nil error in ErrorTryComputeFactorialFromNegativeNumber")
        XCTAssertNotNil(result.error!.userInfo, "nil error userInfo in ErrorTryComputeFactorialFromNegativeNumber")
        
        let rangeOfErrorPart = result.error?.userInfo?[Calculator.PublicConstants.RangeOfErrorPartExpression] as? NSRange
        
        XCTAssertNotNil(rangeOfErrorPart, "nil error userInfo rangeOfErrorPart in ErrorTryComputeFactorialFromNegativeNumber")
        XCTAssert( NSEqualRanges(rangeOfErrorPart!, NSMakeRange(2, 1)),
            "uncorrect rangeOfErrorPart in ErrorTryComputeFactorialFromNegativeNumber")
        
        
        println(result.error!.domain)
        
    }
    
    
}