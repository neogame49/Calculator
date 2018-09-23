//
//  CalculatorErrorTests.swift
//  CalculatorOnSwift
//
//  Created by Macbook on 19.02.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

import Foundation
import XCTest
@testable import Calculator

class CalculatorTestsErrorCases: XCTestCase {
    var calculator: Calculator!
    
       override func setUp() {
        super.setUp()
        
        calculator = Calculator(expression: "")
        
        calculator.dataSource = self
        calculator.delegate = self
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEmptyExpression() {
        calculator.expression = ""
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.emptyExpression {
            
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorNumberFormarCase() {
        calculator.expression = "2.2.2+2..2"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.wrongFormatOfNumber(let errorRange) {
            XCTAssertEqual(errorRange, 0..<5, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorMissingCloseBracket() {
        calculator.expression = "2+(2+2"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.missingClosedBracket(let errorRange) {
            XCTAssertEqual(errorRange, 2..<3, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorMissingOpenBracket() {
        calculator.expression = "2+2+2)"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.missingOpenedBracket(let errorRange) {
            XCTAssertEqual(errorRange, 5..<6, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorTryToUseUndefineVariables() {
        calculator.expression = "2 - undefVar1 + undefVar2"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.undefinedVariable(let errorRange) {
            XCTAssertEqual(errorRange, 4..<13, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorTryToComputedUndefineFunction() {
        calculator.expression = "undefFunc(2)"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.undefinedVariable(let errorRange) {
            XCTAssertEqual(errorRange, 0..<9, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorExpresionWithUndefineSumbols() {
        calculator.expression = "2?2@5"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.undefineOrIncorectUsedOfTheDelimiter(let errorRange) {
            XCTAssertEqual(errorRange, 1..<2, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorToMuchUnaryOperators() {
        calculator.expression = "2+ --3+ +++4"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.undefineOrIncorectUsedOfTheDelimiter(let errorRange) {
            XCTAssertEqual(errorRange, 4..<5, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorDivByZero() {
        calculator.expression = "2/(2-2)"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.divByZero(let errorRange) {
            XCTAssertEqual(errorRange, 1..<2, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testMissingSecondOperand() {
        calculator.expression = "2^2^"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.missingArgument(let errorRange) {
            XCTAssertEqual(errorRange, 3..<4, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorCommaOutsideOfFunction() {
        calculator.expression = "max(2,Pi),"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.undefineOrIncorectUsedOfTheDelimiter(let errorRange) {
            XCTAssertEqual(errorRange, 9..<10, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorMissingArgumentInsideOfFunction() {
        calculator.expression = "max(2,)"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.missingArgument(let errorRange) {
            XCTAssertEqual(errorRange, 0..<3, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorTryAssignedValueToConstant() {
        calculator.expression = "Pi=5"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.undefineOrIncorectUsedOfTheDelimiter(let errorRange) {
            XCTAssertEqual(errorRange, 2..<3, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorNotPrefixUnaryDelimiterToAForwardExpresion() {
        calculator.expression = "!3*4"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.undefineOrIncorectUsedOfTheDelimiter(let errorRange) {
            XCTAssertEqual(errorRange, 0..<1, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
    
    func testErrorTryComputeFactorialFromNegativeNumber() {
        calculator.expression = "-5!"
        
        do {
            let _ = try calculator.eval()
            XCTFail("calculator error hasn'n occured")
        } catch CalculatorError.factorialFromNegativeNumber(let errorRange) {
            XCTAssertEqual(errorRange, 2..<3, "wrong error range")
        } catch {
            XCTFail("incorrect type of calculator error")
        }
    }
}

// MARK:- CalculatorDataSource
extension CalculatorTestsErrorCases : CalculatorDataSource {
    func constantVariables(_ calculator: Calculator) -> [String: NSDecimalNumber] {
        return ["Pi": NSDecimalNumber(string: "3.14"), "exp": NSDecimalNumber(string: "2.7")]
    }
    
    func functions(_ calculator: Calculator) -> Set<String> {
        return ["sin","cos","max","min"]
    }
}

// MARK:- CalculatorDelegate
extension CalculatorTestsErrorCases: CalculatorDelegate {
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
