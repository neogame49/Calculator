//
//  CalculatorTest.swift
//  CalculatorOnSwift
//
//  Created by Macbook on 19.02.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

import Foundation
import XCTest
import Calculator


// MARK:- Calculator tests
class CalculatorTests: XCTestCase, CalculatorDataSource, CalculatorDelegate
{
    var calculator: Calculator!
    var cachedVariables = [String: NSDecimalNumber]()
    
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
    
    func cacheVariablesForCalculator(calculator: Calculator, variables: [String: NSDecimalNumber])
    {
        cachedVariables = variables
        
    }
    
    func calculateForCalculator(calculator: Calculator, function: String, params: [NSDecimalNumber],
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
    
    override func setUp() {
        super.setUp()
        
        calculator = Calculator(expression: "")
        
        calculator.dataSource = self
        calculator.delegate = self
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSimpleAddCase()
    {
        self.calculator.expression = "2+2"
        
        let result = self.calculator.eval()
        
        XCTAssertNotNil(result.result, "nil result in SimpleAddCase ")
        XCTAssertNil(result.error, "not nil error in SimpleAddCase")
        XCTAssertEqual(result.result!, NSDecimalNumber(string: "4"), "not equal get result with etalon result in SimpleAddCase")
        
    }
    
    func testSimpleSubCase()
    {
        self.calculator.expression = "4-2"
        
        let result = self.calculator.eval()
        
        XCTAssertNotNil(result.result, "nil result in SimpleSubCase ")
        XCTAssertNil(result.error, "not nil error in SimpleSubCase")
        XCTAssertEqual(result.result!, NSDecimalNumber(string: "2"), "not equal get result with etalon result in SimpleSubCase")
        
    }
    func testSubWithMinusCase()
    {
        self.calculator.expression = "2-4"
        
        let result = self.calculator.eval()
        
        XCTAssertNotNil(result.result, "nil result in SubWithMinusCase ")
        XCTAssertNil(result.error, "not nil error in SubWithMinusCase")
        XCTAssertEqual(result.result!, NSDecimalNumber(string: "-2"), "not equal get result with etalon result in SubWithMinusCase")
        
    }
    
    func testSimpleMulCase()
    {
        self.calculator.expression = "3*3"
        
        let result = self.calculator.eval()
        
        XCTAssertNotNil(result.result, "nil result in SimpleMulCase ")
        XCTAssertNil(result.error, "not nil error in SimpleMulCase")
        XCTAssertEqual(result.result!, NSDecimalNumber(string: "9"), "not equal get result with etalon result in SimpleMulCase")
        
    }
    
    func testSimpleDivCase()
    {
        self.calculator.expression = "6/2"
        
        let result = self.calculator.eval()
        
        XCTAssertNotNil(result.result, "nil result in SimpleDivCase ")
        XCTAssertNil(result.error, "not nil error in SimpleDivCase")
        XCTAssertEqual(result.result!, NSDecimalNumber(string: "3"), "not equal get result with etalon result in SimpleDivCase")
    }
    
    func testSimpleRasingToPowerCase()
    {
        self.calculator.expression = "3^2"
        
        let result = self.calculator.eval()
        
        XCTAssertNotNil(result.result, "nil result in RasingToPowerCase ")
        XCTAssertNil(result.error, "not nil error in RasingToPowerCase")
        XCTAssertEqual(result.result!, NSDecimalNumber(string: "9"), "not equal get result with etalon result in RasingToPowerCase")
    }
    
    func testSimpleFactorialCase()
    {
        self.calculator.expression = "5!"
        
        let result = self.calculator.eval()
        
        XCTAssertNotNil(result.result, "nil result in SimpleFactorialCase ")
        XCTAssertNil(result.error, "not nil error in SimpleFactorialCase")
        XCTAssertEqual(result.result!, NSDecimalNumber(string: "120"), "not equal get result with etalon result in SimpleFactorialCase")
    }
    
    func testSimpleUnarryPlusCase()
    {
        self.calculator.expression = "+5-3"
        
        let result = self.calculator.eval()
        
        XCTAssertNotNil(result.result, "nil result in SimpleUnarryPlusCase ")
        XCTAssertNil(result.error, "not nil error in SimpleUnarryPlusCase")
        XCTAssertEqual(result.result!, NSDecimalNumber(string: "2"), "not equal get result with etalon result in SimpleUnarryPlusCase")
    }
    
    func testSimpleUnarryMinusCase()
    {
        self.calculator.expression = "-5+3"
        
        let result = self.calculator.eval()
        
        XCTAssertNotNil(result.result, "nil result in SimpleUnarryMinusCase ")
        XCTAssertNil(result.error, "not nil error in SimpleUnarryMinusCase")
        XCTAssertEqual(result.result!, NSDecimalNumber(string: "-2"), "not equal get result with etalon result in SimpleUnarryMinusCase")
    }
    
    func testLongResult()
    {
        self.calculator.expression = "1000000*1000000"
        
        let result = self.calculator.eval()
        
        XCTAssertNotNil(result.result, "nil result in LongResult ")
        XCTAssertNil(result.error, "not nil error in LongResult")
        XCTAssertEqual(result.result!, NSDecimalNumber(string: "1000000000000"), "not equal get result with etalon result in LongResult")
    }
    
    func testSimpleMultipleOperations()
    {
        self.calculator.expression = "2+2*2"
        
        let result = self.calculator.eval()
        
        XCTAssertNotNil(result.result, "nil result in SimpleMultipleOperations ")
        XCTAssertNil(result.error, "not nil error in SimpleMultipleOperations")
        XCTAssertEqual(result.result!, NSDecimalNumber(string: "6"), "not equal get result with etalon result in SimpleMultipleOperations")
    }
    
    func testSimpleMultipleOperationsWithBrackets()
    {
        self.calculator.expression = "(2+2)*2"
        
        let result = self.calculator.eval()
        
        XCTAssertNotNil(result.result, "nil result in SimpleMultipleOperationsWithBrackets ")
        XCTAssertNil(result.error, "not nil error in SimpleMultipleOperationsWithBrackets")
        XCTAssertEqual(result.result!, NSDecimalNumber(string: "8"), "not equal get result with etalon result in SimpleMultipleOperationsWithBrackets")
    }
    
    func testExpresionWithWhiteSpaces()
    {
        self.calculator.expression = "10  + 5 -      6"
        
        let result = self.calculator.eval()
        
        XCTAssertNotNil(result.result, "nil result in ExpresionWithWhiteSpaces ")
        XCTAssertNil(result.error, "not nil error in ExpresionWithWhiteSpaces")
        XCTAssertEqual(result.result!, NSDecimalNumber(string: "9"), "not equal get result with etalon result in ExpresionWithWhiteSpaces")
    }
    
    func testSingleNumber()
    {
        self.calculator.expression = "85"
        
        let result = self.calculator.eval()
        
        XCTAssertNotNil(result.result, "nil result in SingleNumber ")
        XCTAssertNil(result.error, "not nil error in SingleNumber")
        XCTAssertEqual(result.result!, NSDecimalNumber(string: "85"), "not equal get result with etalon result in SingleNumber")
    }
    
    func testSingleConstVariable()
    {
        self.calculator.expression = "Pi"
        
        let result = self.calculator.eval()
        
        XCTAssertNotNil(result.result, "nil result in SingleConstVariable ")
        XCTAssertNil(result.error, "not nil error in SingleConstVariable")
        XCTAssertEqual(result.result!, NSDecimalNumber(string: "3.14"), "not equal get result with etalon result in SingleConstVariable")
    }
    
    func testExpresionWihtConstVariables()
    {
        self.calculator.expression = "Pi + exp^2 - 3"
        
        let result = self.calculator.eval()
        
        XCTAssertNotNil(result.result, "nil result in SingleConstVariable ")
        XCTAssertNil(result.error, "not nil error in SingleConstVariable")
        XCTAssertEqual(result.result!, NSDecimalNumber(string: "7.43"), "not equal get result with etalon result in SingleConstVariable")
    }
    func testCalculateSingleFunctionWithOneArgument1()
    {
        self.calculator.expression = "sin(0)"
        
        let result = self.calculator.eval()
        
        XCTAssertNotNil(result.result, "nil result in CalculateSingleFunctionWithOneArgument1 ")
        XCTAssertNil(result.error, "not nil error in CalculateSingleFunctionWithOneArgument1")
        XCTAssertEqual(result.result!, NSDecimalNumber(string: "0"), "not equal get result with etalon result in CalculateSingleFunctionWithOneArgument1")
    }
    func testCalculateSingleFunctionWithTwoArgument1()
    {
        self.calculator.expression = "max(2,5)"
        
        let result = self.calculator.eval()
        
        XCTAssertNotNil(result.result, "nil result in CalculateSingleFunctionWithTwoArgument1 ")
        XCTAssertNil(result.error, "not nil error in CalculateSingleFunctionWithTwoArgument1")
        XCTAssertEqual(result.result!, NSDecimalNumber(string: "5"), "not equal get result with etalon result in CalculateSingleFunctionWithTwoArgument1")
    }
    func testCalculateSingleFunctionWithTwoArgument2()
    {
        self.calculator.expression = "min(2,-5)"
        
        let result = self.calculator.eval()
        
        XCTAssertNotNil(result.result, "nil result in CalculateSingleFunctionWithTwoArgument2 ")
        XCTAssertNil(result.error, "not nil error in CalculateSingleFunctionWithTwoArgument2")
        XCTAssertEqual(result.result!, NSDecimalNumber(string: "-5"), "not equal get result with etalon result in CalculateSingleFunctionWithTwoArgument2")
    }
    func testCalculateExpresionWithAsignedVariable()
    {
        let varName = "var"
        self.calculator.expression = "\(varName)=2+2"
        
        let result = self.calculator.eval()
        calculator.cacheVariablesIfNeeded()
        
        XCTAssertNotNil(result.result, "nil result in CalculateExpresionWithAsignedVariable ")
        XCTAssertNil(result.error, "not nil error in CalculateExpresionWithAsignedVariable")
        XCTAssertEqual(result.result!, NSDecimalNumber(string: "4"), "not equal get result with etalon result in CalculateExpresionWithAsignedVariable")
        XCTAssert(!cachedVariables.isEmpty, "Failed cache in CalculateExpresionWithAsignedVariable case")
        XCTAssertEqual(cachedVariables[varName]!, NSDecimalNumber(string: "4"),
            "Wrong cached value into \(varName) variable in CalculateExpresionWithAsignedVariable case")
    }
    
}
