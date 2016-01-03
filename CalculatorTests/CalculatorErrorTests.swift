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

@testable import Calculator

class CalculatorTestsErrorCases: XCTestCase, CalculatorDataSource, CalculatorDelegate
{
    var calculator: Calculator!
    
    // MARK:- CalculatorDataSource
    func constantVariables(calculator: Calculator) -> [String: NSDecimalNumber] {
            return ["Pi": NSDecimalNumber(string: "3.14"), "exp": NSDecimalNumber(string: "2.7")]
    }
    
    func functions(calculator: Calculator) -> Set<String> {
            return ["sin","cos","max","min"]
    }
    
    // MARK:- CalculatorDelegate
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
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.WrongFormatOfNumber(let errorRange) {
            XCTAssertEqual(errorRange, 0..<5, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorMissingCloseBracket()
    {
        calculator.expression = "2+(2+2"
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.MissingClosedBracket(let errorRange) {
            XCTAssertEqual(errorRange, 2..<3, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorMissingOpenBracket()
    {
        calculator.expression = "2+2+2)"
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.MissingOpenedBracket(let errorRange) {
            XCTAssertEqual(errorRange, 5..<6, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorTryToUseUndefineVariables()
    {
        calculator.expression = "2 - undefVar1 + undefVar2"
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.UndefinedVariable(let errorRange) {
            XCTAssertEqual(errorRange, 4..<13, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorTryToComputedUndefineFunction()
    {
        calculator.expression = "undefFunc(2)"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.UndefinedVariable(let errorRange) {
            XCTAssertEqual(errorRange, 0..<9, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorExpresionWithUndefineSumbols()
    {
        calculator.expression = "2?2@5"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.UndefineOrIncorectUsedOfTheDelimiter(let errorRange) {
            XCTAssertEqual(errorRange, 1..<2, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorToMuchUnaryOperators()
    {
        calculator.expression = "2+ --3+ +++4"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.UndefineOrIncorectUsedOfTheDelimiter(let errorRange) {
            XCTAssertEqual(errorRange, 4..<5, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorDivByZero()
    {
        calculator.expression = "2/(2-2)"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.DivByZero(let errorRange) {
            XCTAssertEqual(errorRange, 1..<2, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testMissingSecondOperand()
    {
        calculator.expression = "2^2^"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.MissingArgument(let errorRange) {
            XCTAssertEqual(errorRange, 3..<4, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorCommaOutsideOfFunction()
    {
        calculator.expression = "max(2,Pi),"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.UndefineOrIncorectUsedOfTheDelimiter(let errorRange) {
            XCTAssertEqual(errorRange, 9..<10, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorMissingArgumentInsideOfFunction()
    {
        calculator.expression = "max(2,)"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.MissingArgument(let errorRange) {
            XCTAssertEqual(errorRange, 0..<3, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorTryAssignedValueToConstant()
    {
        calculator.expression = "Pi=5"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.UndefineOrIncorectUsedOfTheDelimiter(let errorRange) {
            XCTAssertEqual(errorRange, 2..<3, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorNotPrefixUnaryDelimiterToAForwardExpresion()
    {
        calculator.expression = "!3*4"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.UndefineOrIncorectUsedOfTheDelimiter(let errorRange) {
            XCTAssertEqual(errorRange, 0..<1, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorTryComputeFactorialFromNegativeNumber()
    {
        calculator.expression = "-5!"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.FactorialFromNegativeNumber(let errorRange) {
            XCTAssertEqual(errorRange, 2..<3, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
}