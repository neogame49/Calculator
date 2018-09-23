//
//  CalculatorTest.swift
//  CalculatorOnSwift
//
//  Created by Macbook on 19.02.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

import Foundation
import XCTest
@testable import Calculator

// MARK:- Calculator tests
class CalculatorTests: XCTestCase {
    var calculator: Calculator!
    var cachedVariables = [String: NSDecimalNumber]()
    
    override func setUp() {
        super.setUp()
        
        calculator = Calculator(expression: "")
        
        calculator.dataSource = self
        calculator.delegate = self
        
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSimpleAddCase() {
        self.calculator.expression = "2+2"
        
        do {
            let result = try self.calculator.eval()
            XCTAssertEqual(result, NSDecimalNumber(string: "4"), "retrieved result doesn't equal to etalon result")
        }  catch {
            XCTFail("error has occured")
        }
    }
    
    func testSimpleSubCase() {
        self.calculator.expression = "4-2"
        
        do {
            let result = try self.calculator.eval()
            XCTAssertEqual(result, NSDecimalNumber(string: "2"), "retrieved result doesn't equal to etalon result")
        }  catch {
            XCTFail("error has occured")
        }
    }
    func testSubWithMinusCase() {
        self.calculator.expression = "2-4"
        
        do {
            let result = try self.calculator.eval()
            XCTAssertEqual(result, NSDecimalNumber(string: "-2"), "retrieved result doesn't equal to etalon result")
        }  catch {
            XCTFail("error has occured")
        }
    }
    
    func testSimpleMulCase() {
        self.calculator.expression = "3*3"
        
        do {
            let result = try self.calculator.eval()
            XCTAssertEqual(result, NSDecimalNumber(string: "9"), "retrieved result doesn't equal to etalon result")
        }  catch {
            XCTFail("error has occured")
        }
    }
    
    func testSimpleDivCase() {
        self.calculator.expression = "6/2"
        
        do {
            let result = try self.calculator.eval()
            XCTAssertEqual(result, NSDecimalNumber(string: "3"), "retrieved result doesn't equal to etalon result")
        }  catch {
            XCTFail("error has occured")
        }
    }
    
    func testSimpleRasingToPowerCase() {
        self.calculator.expression = "3^2"
        
        do {
            let result = try self.calculator.eval()
            XCTAssertEqual(result, NSDecimalNumber(string: "9"), "retrieved result doesn't equal to etalon result")
        }  catch {
            XCTFail("error has occured")
        }
    }
    
    func testSimpleFactorialCase() {
        self.calculator.expression = "5!"
        
        do {
            let result = try self.calculator.eval()
            XCTAssertEqual(result, NSDecimalNumber(string: "120"), "retrieved result doesn't equal to etalon result")
        }  catch {
            XCTFail("error has occured")
        }
    }
    
    func testSimpleUnarryPlusCase() {
        self.calculator.expression = "+5-3"
        
        do {
            let result = try self.calculator.eval()
            XCTAssertEqual(result, NSDecimalNumber(string: "2"), "retrieved result doesn't equal to etalon result")
        }  catch {
            XCTFail("error has occured")
        }
    }
    
    func testSimpleUnarryMinusCase() {
        self.calculator.expression = "-5+3"
        
        do {
            let result = try self.calculator.eval()
            XCTAssertEqual(result, NSDecimalNumber(string: "-2"), "retrieved result doesn't equal to etalon result")
        }  catch {
            XCTFail("error has occured")
        }
    }
    
    func testLongResult() {
        self.calculator.expression = "1000000*1000000"
        
        do {
            let result = try self.calculator.eval()
            XCTAssertEqual(result, NSDecimalNumber(string: "1000000000000"), "retrieved result doesn't equal to etalon result")
        }  catch {
            XCTFail("error has occurs")
        }
    }
    
    func testSimpleMultipleOperations() {
        self.calculator.expression = "2+2*2"
        
        do {
            let result = try self.calculator.eval()
            XCTAssertEqual(result, NSDecimalNumber(string: "6"), "retrieved result doesn't equal to etalon result")
        }  catch {
            XCTFail("error has occured")
        }
    }
    
    func testSimpleMultipleOperationsWithBrackets() {
        self.calculator.expression = "(2+2)*2"
        
        do {
            let result = try self.calculator.eval()
            XCTAssertEqual(result, NSDecimalNumber(string: "8"), "retrieved result doesn't equal to etalon result")
        }  catch {
            XCTFail("error has occured")
        }
    }
    
    func testExpresionWithWhiteSpaces(){
        self.calculator.expression = "10  + 5 -      6"
        
        do {
            let result = try self.calculator.eval()
            XCTAssertEqual(result, NSDecimalNumber(string: "9"), "retrieved result doesn't equal to etalon result")
        }  catch {
            XCTFail("error has occured")
        }
    }
    
    func testSingleNumber() {
        self.calculator.expression = "85"
        
        do {
            let result = try self.calculator.eval()
            XCTAssertEqual(result, NSDecimalNumber(string: "85"), "retrieved result doesn't equal to etalon result")
        }  catch {
            XCTFail("error has occured")
        }
    }
    
    func testSingleConstVariable() {
        self.calculator.expression = "Pi"
        
        do {
            let result = try self.calculator.eval()
            XCTAssertEqual(result, NSDecimalNumber(string: "3.14"), "retrieved result doesn't equal to etalon result")
        }  catch {
            XCTFail("error has occured")
        }
    }
    
    func testExpresionWihtConstVariables() {
        self.calculator.expression = "Pi + exp^2 - 3"
        
        do {
            let result = try self.calculator.eval()
            XCTAssertEqual(result, NSDecimalNumber(string: "7.43"), "retrieved result doesn't equal to etalon result")
        }  catch {
            XCTFail("error has occured")
        }

    }
    func testCalculateSingleFunctionWithOneArgument1() {
        self.calculator.expression = "sin(0)"
        
        do {
            let result = try self.calculator.eval()
            XCTAssertEqual(result, NSDecimalNumber(string: "0"), "retrieved result doesn't equal to etalon result")
        }  catch {
            XCTFail("error has occured")
        }

    }
    func testCalculateSingleFunctionWithTwoArgument1() {
        self.calculator.expression = "max(2,5)"
        
        do {
            let result = try self.calculator.eval()
            XCTAssertEqual(result, NSDecimalNumber(string: "5"), "retrieved result doesn't equal to etalon result")
        }  catch {
            XCTFail("error has occured")
        }

    }
    func testCalculateSingleFunctionWithTwoArgument2() {
        self.calculator.expression = "min(2,-5)"
        
        do {
            let result = try self.calculator.eval()
            XCTAssertEqual(result, NSDecimalNumber(string: "-5"), "retrieved result doesn't equal to etalon result")
        }  catch {
            XCTFail("error has occured")
        }

    }
    func testCalculateExpresionWithAsignedVariable() {
        let varName = "var"
        self.calculator.expression = "\(varName)=2+2"
        
        do {
            let result = try self.calculator.eval()
            XCTAssertEqual(result, NSDecimalNumber(string: "4"), "retrieved result doesn't equal to etalon result")
            
            calculator.cacheVariablesIfNeeded()
            XCTAssert(!self.cachedVariables.isEmpty, "Failed cache ")
            XCTAssertEqual(cachedVariables[varName]!, NSDecimalNumber(string: "4"),
                "Wrong cached value into \(varName) variable")

        }  catch {
            XCTFail("error has occured")
        }
    }
    
}

// MARK:- CalculatorDataSource
extension CalculatorTests : CalculatorDataSource {
    func constantVariables(_ calculator: Calculator) -> [String: NSDecimalNumber] {
        return ["Pi": NSDecimalNumber(string: "3.14"), "exp": NSDecimalNumber(string: "2.7")]
    }
    
    func functions(_ calculator: Calculator) -> Set<String> {
        return ["sin","cos","max","min"]
    }
}

// MARK:- CalculatorDelegate
extension CalculatorTests: CalculatorDelegate {
    func cacheVariablesForCalculator(_ calculator: Calculator, variables: [String: NSDecimalNumber]) {
        cachedVariables = variables
    }
    
    func calculateForCalculator(_ calculator: Calculator, function: String, params: [NSDecimalNumber]) throws -> NSDecimalNumber {
        switch(function) {
        case "sin":
            if params.count != 1 {
                throw NSError(domain: "wrong number of argument for sin function", code: 20000, userInfo: nil)
            }
            return NSDecimalNumber(value: sin(params.first!.doubleValue) as Double)
        case "cos":
            if params.count != 1 {
                throw NSError(domain: "wrong number of argument for cos function", code: 20000, userInfo: nil)
            }
            return NSDecimalNumber(value: cos(params.first!.doubleValue) as Double)
        case "max":
            if params.count != 2 {
                throw NSError(domain: "wrong number of argument for max function", code: 20000, userInfo: nil)
            }
            return NSDecimalNumber(value: max(params[0].doubleValue, params[1].doubleValue) as Double)
        case "min":
            if params.count != 2 {
                throw  NSError(domain: "wrong number of argument for min function", code: 20000, userInfo: nil)
            }
            return NSDecimalNumber(value: min(params[0].doubleValue, params[1].doubleValue) as Double)
        default:
            throw NSError(domain: "unknown \(function) function", code: 20000, userInfo: nil)
        }
        
    }
}
