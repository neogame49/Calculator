//
//  Calculator.swift
//  CalculatorOnSwift
//
//  Created by Macbook on 07.02.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

import UIKit
import Foundation



public class Calculator: NSObject
    
{
// MARK:- interface
    public struct PublicConstants
    {
        public static let RangeOfErrorPartExpression = "com.sherbiyRoman/Calculator RangeOfErrorPartExpression"
    }
    weak public var dataSource: CalculatorDataSource?
    {
        didSet
        {
           reloadData()
        }
    }
    weak public var delegate: CalculatorDelegate?
    
    public var expression: String
    {
        didSet
        {
            token = ""
            tokenType = .None
            index = 0
            error = nil
        }
    }
    
    public func reloadData()
    {
        constVariables = dataSource?.constVariables? ?? [String: NSDecimalNumber]()
        functions = dataSource?.functions? ?? [String]()
        
        cacheVariablesIfNeeded()
        
        if let newVariables = dataSource?.variables?
        {
            variables = newVariables
        }
    }
    
    public func cacheVariablesIfNeeded()
    {
        if needCacheVariables == true
        {
            cacheVariables()
        }
    }
    public func cacheVariables()
    {
        delegate?.cacheVariablesForCalculator?(self, variables: self.variables)
        needCacheVariables = false
    }
    
    public func eval() -> (result: NSDecimalNumber?, error: NSError?)
    {
        var result: NSDecimalNumber? = nil
        
        getToken()
        eval0(&result)
        
        if  tokenType == .Delimiter && error == nil // uncorrect used delimiter
        {
            handleDelimiterAtomCase()
        }
        
        if error != nil
        {
            return (nil, error)
        }
        
        if result == nil && error == nil // empty expresion case
        {
            error = NSError(domain: "empty expression", code: 10000, userInfo: nil)
            
            return (nil, error)
        }
        
        
        
        return(result, nil) // normal result without error
    }
    
    // MARK:- init
    public init(expression: String)
    {
        self.expression = expression
    }
    public override convenience init()
    {
        self.init(expression: "")
    }
    deinit
    {
        cacheVariablesIfNeeded()
    }
    
    
    
    // MARK:- implimetantion, private section
    
    private enum TokenType
    {
        case Delimiter
        case Number
        case ConstVariable
        case Variable
        case Function
        case None     // none type
        case Error
        
    }
    
    private struct PrivateConstants
    {
        static let paternForNumber = "(?<=^| )\\d+(\\.\\d+)?(?=$| )" // only case like 1 or 1.2
    }
    
    private var token = ""
    private var tokenType = TokenType.None
    private var index = 0
    private var error: NSError?{
        didSet
        {
            if error != nil && oldValue != nil
            {
                error = oldValue // cant replaced by a early error at a later
            }
            
            if error != nil
            {
                token = ""
                tokenType = .Error
            }
        }
    }
    private var needCacheVariables = false
    
    private var functions = [String]()
    private var constVariables = [String: NSDecimalNumber]()
    private var variables = [String: NSDecimalNumber]()
    
    private var openBracketsStack = Stack<Bool>()
    private var insideFunctionStack = Stack<Bool>()

    
    private var endOfExpresion : Int
    {
        return countElements(expression)
    }
    
    private func getToken()
    {
        token = ""
        tokenType = .None
        
        if index == endOfExpresion
        {
            return
        }
        var currentSumbol = expression[index]
        
        while currentSumbol == " "
        {
            index++
            if index == endOfExpresion
            {
                return
            }
            currentSumbol = expression[index]
        }
        
        //====================
        
        if currentSumbol.isDelimiter
        {
            token += String(currentSumbol)
            tokenType = .Delimiter
            index++
        }
        else if currentSumbol.isDigit
        {
            tokenType = .Number

            while currentSumbol.isDigit || currentSumbol == "."
            {
                token += String(currentSumbol)
                index++

                if index == endOfExpresion
                {
                    break
                }
                currentSumbol = expression[index]
            }
        }
        else if currentSumbol.isLettet || currentSumbol == "_"
        {
            tokenType = .Variable
            
            while currentSumbol.isLettet || currentSumbol == "_" ||
            currentSumbol.isDigit
            {
                token += String(currentSumbol)
                index++
                
                if index == endOfExpresion
                {
                    break
                }
                currentSumbol = self.expression[index]
            }
        }
        else
        {
            error = NSError(domain: "Unknown or uncorrect use of symbols \(currentSumbol)", code: 1000, userInfo: [PublicConstants.RangeOfErrorPartExpression :
                rangeOfToken(String(currentSumbol), index: index+1)])
            return
        }
        
        if tokenType == .Number && !(token =~ PrivateConstants.paternForNumber)
        {
            error = NSError(domain: "wrong format for number \(token)", code: 1000, userInfo: [PublicConstants.RangeOfErrorPartExpression : rangeOfCurrentToken])
            return
        }
        
        if tokenType == .Variable
        {
            if isTokenConstVariable
            {
                tokenType = .ConstVariable
            }
            else if isTokenFunction
            {
                tokenType = .Function
            }
            
        }
        
    }
    // MARK:- calculate methods
    private func eval0(inout result: NSDecimalNumber?)
    {
        if tokenType == .Variable
        {
            let tempToken = token
            getToken()
            
            if token != "="
            {
                index = 0 // move to start
                getToken()
            }
            else
            {
               getToken()
               eval1(&result)
                
                if result != nil && error == nil
                {
                    variables[tempToken] = result!
                    needCacheVariables = true;
                }
                return
            }
        }
        
        eval1(&result)
    }
    private func eval1(inout result: NSDecimalNumber?)
    {
        eval2(&result)
        
        var tempValue: NSDecimalNumber?
        
        var op = token
        var indexOfOp = index
        
        while op == "+" || op == "-"
        {
            getToken()
            tempValue = nil
            eval2(&tempValue)
            
            if result != nil && tempValue != nil
            {
                switch(op)
                {
                case "+":
                   result = result! + tempValue!
                case "-":
                    result = result! - tempValue!
                default:
                    break;
                }
            }
            else if tempValue == nil  // missing second argument
            {
                error = NSError(domain: "Missing second argument after \(op)", code: 10000, userInfo:[PublicConstants.RangeOfErrorPartExpression : rangeOfToken(op, index: indexOfOp)])
                break
            }
            op = token
            indexOfOp = index
        }
        
    }
    
    private func eval2(inout result: NSDecimalNumber?)
    {
        eval3(&result)
        
        var tempValue: NSDecimalNumber?
        
        var op = token
        var indexOfOp = index
        
        while op == "*" || op == "/"
        {
            getToken()
            tempValue = nil
            eval3(&tempValue)
            
            if result != nil && tempValue != nil
            {
                switch(op)
                {
                case "*":
                    result = result! * tempValue!
                case "/":
                    if tempValue == NSDecimalNumber(string: "0") // div by zero case
                    {
                        error = NSError(domain: "div by zero", code: 10000, userInfo:
                        [PublicConstants.RangeOfErrorPartExpression : rangeOfToken(op, index: indexOfOp)])
                        return
                    }
                    else
                    {
                        result = result! / tempValue!
                    }
                default:
                    break;
                }
            }
            else if tempValue == nil // missing second argument
            {
                error = NSError(domain: "Missing second argument after \(op)", code: 10000, userInfo: [PublicConstants.RangeOfErrorPartExpression : rangeOfToken(op, index: indexOfOp)])
                break
            }
            
            op = token
            indexOfOp = index
        }
    }
    
    private func eval3(inout result: NSDecimalNumber?)
    {
        eval4(&result)
        
        var tempValue: NSDecimalNumber? = nil
        
        var indexOfDelimiter = index
        
        if token == "^"
        {
            getToken()
            eval3(&tempValue)
            
            if result != nil && tempValue != nil
            {
               result = result! ^ tempValue!
            }
            else if tempValue == nil // missing second argument
            {
                error = NSError(domain: "Missing second argument after ^", code: 10000, userInfo:[PublicConstants.RangeOfErrorPartExpression : rangeOfToken("^", index: indexOfDelimiter)])
                return
            }
        }
    }
    
    private func eval4(inout result: NSDecimalNumber?)
    {
        eval5(&result)
        
        while token == "!"
        {
            if result != nil
            {
                if let factorialResult = (result!)^!
                {
                    result = factorialResult
                }
                else
                {
                    error = NSError(domain: "Factorial is defined only for non-negative integers", code:10000, userInfo: [PublicConstants.RangeOfErrorPartExpression : rangeOfCurrentToken])
                    return
                }
                
                getToken()
            }
        }
    }
    
    private func eval5(inout result: NSDecimalNumber?)
    {
        var op = ""
        
        if token == "+" || token == "-" // unarry + or -
        {
            op = token
            getToken()
        }
        
        eval6(&result)
        
        if op == "-"
        {
            if result != nil
            {
                result = -(result!)
            }
        }
    }
    
    private func eval6(inout result: NSDecimalNumber?)
    {
        if tokenType == .Function
        {
            let function = token
            let indexOfFunction = index
            
            getToken()
            
            if token != "("
            {
                error = NSError(domain: "missing open bracket  before \(function) function",
                    code: 10000, userInfo: [PublicConstants.RangeOfErrorPartExpression :
                        rangeOfToken(function, index: indexOfFunction)])
                return
            }
            openBracketsStack.push(true)
            insideFunctionStack.push(true)
            
            let params = getParametersForFuction(function, atIndex: indexOfFunction)
            
            if (params == nil)
            {
                return
            }
            
            if token != ")"
            {
                error = NSError(domain: "missing close bracket ", code: 10000, userInfo: [PublicConstants.RangeOfErrorPartExpression : rangeOfToken(function + "(", index: indexOfFunction)])
                return
            }
            
            openBracketsStack.pop()
            insideFunctionStack.pop()
            
            // try coumput function
            if let functionResult = delegate?.calculateForCalculator?(self, function: function, params: params!, handleError: { err in self.error = err })
            {
                result = functionResult
                getToken()
            }
            else
            {
                if error == nil
                {
                    error = NSError(domain: "faild coumputed \(function) function", code: 10000, userInfo: [PublicConstants.RangeOfErrorPartExpression : rangeOfToken(function, index: indexOfFunction)])
                }
                return
            }
            
        }
        else
        {
            eval7(&result)
        }
    }
    
    private func eval7(inout result: NSDecimalNumber?)
    {
        if token == "("
        {
            let indexOfOpenBracket = index
            
            openBracketsStack.push(true)
            
            getToken()
            eval1(&result)
            
            if token != ")"
            {
                error = NSError(domain: "missing close bracket", code: 10000, userInfo:
                    [PublicConstants.RangeOfErrorPartExpression : rangeOfToken("(", index: indexOfOpenBracket)])
                return
            }
            openBracketsStack.pop()
            
            getToken()
        }
        else
        {
            atom(&result)
        }
    }
    
    private func atom(inout result: NSDecimalNumber?)
    {
        switch(tokenType)
        {
        case .Number:
            result = NSDecimalNumber(string: token)
            getToken()
        case .ConstVariable:
            result = constVariables[token]
            getToken()
        case .Variable:
            if let variable = variables[token]
            {
                result = variable
                getToken()
            }
            else
            {
                result = nil
                error = NSError(domain: "undefine \(self.token) variable", code: 10000, userInfo: [PublicConstants.RangeOfErrorPartExpression : rangeOfCurrentToken])
            }
        case .Delimiter:
            handleDelimiterAtomCase()
        case .Error:
            result = nil
        default:
            break
        }
    }
    
    private func getParametersForFuction(function: String, atIndex index: Int) -> [NSDecimalNumber]?
    {
        var result = [NSDecimalNumber]()
        
        do
        {
            var parameter: NSDecimalNumber? = nil
            
            getToken()
            eval1(&parameter)
            
            if parameter != nil && error == nil
            {
                result.append(parameter!)
            }
            else
            {
                if error == nil
                {
                    error = NSError(domain: "missing argument into function", code: 10000, userInfo: [PublicConstants.RangeOfErrorPartExpression : rangeOfToken(function, index: index)])
                }
                
                return nil
            }
        
        }while token == ","
        
        return result
    }
    
    
    // MARK:- supported methods
    private func handleDelimiterAtomCase()
    {
        switch(token)
        {
        case ")" where !openBracketsStack.isEmpty:
            break
        case "," where !insideFunctionStack.isEmpty:
            break
        default:
            error = NSError(domain: "uncorrect use \(token) delimiter", code: 10000,
                userInfo: [PublicConstants.RangeOfErrorPartExpression : rangeOfCurrentToken])
        }
    }
    private var isTokenConstVariable: Bool
    {
        if constVariables[token] != nil
        {
            return true
        }
        
        return false

    }
    
    private var isTokenFunction: Bool
    {
        for function in functions
        {
            if function == token
            {
                return true
            }
        }
        
        
        return false

    }
    private func rangeOfToken(token: String, index: Int) -> NSRange
    {
        let distance = Int(countElements(token))
        let location =  index - (distance)
        
        return NSMakeRange(location, distance)
    }
    
    private var rangeOfCurrentToken: NSRange
    {
        return rangeOfToken(token, index: index)
    }
}




// MARK:- delegate interfaces

@objc public protocol CalculatorDataSource
{
    optional var constVariables: [String: NSDecimalNumber]   {get}
    optional var variables: [String: NSDecimalNumber]        {get}
    //FIXME: replace array to set in Swift 1.2
    optional var functions: [String]                         {get}
    
    
}


@objc public protocol CalculatorDelegate
{
    optional func calculateForCalculator(calculator: Calculator, function: String, params: [NSDecimalNumber], handleError: ((NSError) -> Void)?) -> NSDecimalNumber?
    
    optional func cacheVariablesForCalculator(calculator: Calculator, variables: [String: NSDecimalNumber])
}