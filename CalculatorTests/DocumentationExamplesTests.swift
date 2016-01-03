//
//  DocumentationTests.swift
//  Calculator
//
//  Created by Macbook on 20.02.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

import Foundation
import XCTest
import Calculator

func getMathExp() -> String {
    return arc4random() % 2 == 0 ? "2+2" : "2+2."
}

class DocumentationExamplesTest: XCTestCase, CalculatorDataSource, CalculatorDelegate {
    //MARK:- CalculatorDataSource
    func constantVariables(calculator: Calculator) -> [String: NSDecimalNumber] {
            return ["Pi": NSDecimalNumber(string: "3.1415926535"),
                "e": NSDecimalNumber(string: "2.7182818284")]
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
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
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
        calculator.delegate = self
        
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
    
    func testSixty()
    {
        let calculator = Calculator()
        
        let mathExp = "2..2 - 2"
        calculator.expression = mathExp
        
        do {
            let _ = try calculator.eval()
        } catch CalculatorError.WrongFormatOfNumber(let errorRange) {
            print(mathExp[errorRange])
        } catch {
            // any else errors
        }
    }
}

