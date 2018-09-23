//
//  DocumentationTests.swift
//  Calculator
//
//  Created by Macbook on 20.02.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

import Foundation
import XCTest
@testable import Calculator

func getMathExp() -> String {
    return arc4random() % 2 == 0 ? "2+2" : "2+2."
}

class DocumentationExamplesTest: XCTestCase, CalculatorDataSource, CalculatorDelegate {
    //MARK:- CalculatorDataSource
    func constantVariables(_ calculator: Calculator) -> [String: NSDecimalNumber] {
            return ["Pi": NSDecimalNumber(string: "3.1415926535"),
                "e": NSDecimalNumber(string: "2.7182818284")]
    }
    
    func functions(_ calculator: Calculator) -> Set<String> {
            return ["sin","cos","max","min"]
    }
    
    // MARK:- CalculatorDelegate
    func calculateForCalculator(_ calculator: Calculator, function: String, params: [NSDecimalNumber]) throws -> NSDecimalNumber {
        switch(function)
        {
        case "sin":
            if params.count != 1
            {
                throw NSError(domain: "wrong number of argument for sin function", code: 20000, userInfo: nil)
            }
            return NSDecimalNumber(value: sin(params.first!.doubleValue) as Double)
        case "cos":
            if params.count != 1
            {
                throw NSError(domain: "wrong number of argument for cos function", code: 20000, userInfo: nil)
            }
            return NSDecimalNumber(value: cos(params.first!.doubleValue) as Double)
        case "max":
            if params.count != 2
            {
                throw NSError(domain: "wrong number of argument for max function", code: 20000, userInfo: nil)
            }
            return NSDecimalNumber(value: max(params[0].doubleValue, params[1].doubleValue) as Double)
        case "min":
            if params.count != 2
            {
                throw  NSError(domain: "wrong number of argument for min function", code: 20000, userInfo: nil)
            }
            return NSDecimalNumber(value: min(params[0].doubleValue, params[1].doubleValue) as Double)
        default:
            throw NSError(domain: "unknown \(function) function", code: 20000, userInfo: nil)
        }
    }
    
    func testOne() {
        let mathExp = getMathExp() // String type
        let calculator = Calculator()
        calculator.expression = mathExp
        
        do {
            let result = try calculator.eval()
            print(result)
            
        } catch {
            // Hanlde calculator error
        }
    }
    
    func testTwo() {
        let calculator = Calculator()
        
        calculator.expression = "2+2"
        print(try! calculator.eval()) // print "4"
        
        calculator.expression = "2^3 - 6*3"
        print(try! calculator.eval()) // print "-10"
        
        calculator.expression = "45 + 25/5 - 5!"
        print(try! calculator.eval()) // print "-70"
        
        calculator.expression = " (2+2)*2 + (10* -3)"
        print(try! calculator.eval()) // print "-22"
        
        calculator.expression = " 1 / 5 + 0.005"
        print(try! calculator.eval()) // print "0.205"
    }
    
    func testThere() {
        let calculator = Calculator()
        calculator.dataSource = self
        
        calculator.expression = "Pi + Pi"
        print(try! calculator.eval()) // print "6.283185307"
        
        calculator.expression = "25 + e^2"
        print(try! calculator.eval()) // print "32.38905609860964864"
    }
    
    func testFourty() {
        let calculator = Calculator()
        calculator.dataSource = self
        calculator.delegate = self

        calculator.expression = "2 + cos(0)"
        print(try! calculator.eval()) // print "3"
        
        calculator.expression = "max(2^5, 5!) + min(23, 45/2)"
        print(try! calculator.eval()) // print "142.5"
    }
    
    func testFivety() {
        let calculator = Calculator()
        calculator.dataSource = self
        calculator.delegate = self
        
        calculator.expression = "a = 2"
        print(try! calculator.eval()) // print "2"
        
        calculator.expression = "b = 2 + 2"
        print(try! calculator.eval()) // print "4"
        
        calculator.expression = "c = b - a"
        print(try! calculator.eval()) // print "2"
        
        calculator.expression = " b! - c"
        print(try! calculator.eval()) // print "22"
        
        calculator.expression = "c = c^3"
        print(try! calculator.eval()) // print "8"
        
        calculator.cacheVariablesIfNeeded() // manualy cache variables
        
    } // calculator instance is destroed, variables cached automatically
    
    func testSixty() {
        let calculator = Calculator()
        
        let mathExp = "2..2 - 2"
        calculator.expression = mathExp
        
        do {
            let _ = try calculator.eval()
        } catch CalculatorError.wrongFormatOfNumber(let errorRange) {
            // print wrong part
            let mathExpCharacters = mathExp.characters
            let start = mathExpCharacters.index(mathExpCharacters.startIndex, offsetBy: errorRange.startIndex)
            let end = mathExpCharacters.index(mathExpCharacters.startIndex, offsetBy: errorRange.endIndex - 1)
            
            let wrongPart = String(mathExpCharacters[start...end])
            print(wrongPart)
        } catch {
            // any else errors
        }
    }
}

