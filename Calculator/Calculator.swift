//
//  Calculator.swift
//  CalculatorOnSwift
//
//  Created by Macbook on 07.02.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

// MARK:- Error part
public enum CalculatorError: Error {
    case emptyExpression
    /// Occurs when user passed number like '2.', '2..25' etc.
    /// Also attached range of wrong part of expression.
    case wrongFormatOfNumber(range: CountableRange<Int>)
    /// Occurs when user missed required argument like '2+', 'max(2, )' etc.
    /// Also attached range of  part of expression before missing.
    case missingArgument(range: CountableRange<Int>)
    /// Occurs when user tried div by zero.
    /// Also attached range of  part of expression before missing.
    case divByZero(range: CountableRange<Int>)
    /// Occurs when user tried  get factorial from negative number.
    /// Also attached range of wrong part of expression.
    case factorialFromNegativeNumber(range: CountableRange<Int>)
    /// Occurs when user typed close bracket without opening bracket before.
    /// Also attached range of wrong part of expression.
    case missingOpenedBracket(range: CountableRange<Int>)
    /// Occurs when user didn't type close bracket and opened bracket before.
    /// Also attached range of wrong part of expression.
    case missingClosedBracket(range: CountableRange<Int>)
    /// Occurs when delegate method ... throws error during trying calculate function.
    /// Also attached range of wrong part of expression.
    case failedComputedOfFunction(range: CountableRange<Int>)
    /// Occurs user try use in experession undefined variable( it absent into variables array).
    /// Also attached range of wrong part of expression.
    case undefinedVariable(range: CountableRange<Int>)
    /// Occurs when user passed undefined delimeter or it used is incorect like '2?2', '2++25' etc.
    /// Also attached range of wrong part of expression.
    case undefineOrIncorectUsedOfTheDelimiter(range: CountableRange<Int>)
}

open class Calculator {
// MARK:- interface
    weak open var dataSource: CalculatorDataSource?
    weak open var delegate: CalculatorDelegate?
    
    /// math expression for calculation
    open var expression = "" {
        didSet {
            self.resetTokensStuff()
        }
    }
    
    /// Stores user's own valiables and them values
    /// You might add cached before variables before calculation
    open var variables = [String: NSDecimalNumber]()
    
    /// Cache variaables only if new was added or exist changed a value.
    /// Invoke 'cacheVariablesForCalculator: variables:' method from delegate.
    open func cacheVariablesIfNeeded() {
        if self.needCacheVariables == true {
            self.cacheVariables()
        }
    }
    
    /// Force cache exist variaables in any case.
    /// Invoke 'cacheVariablesForCalculator: variables:' method from delegate.
    open func cacheVariables() {
        self.delegate?.cacheVariablesForCalculator(self, variables: self.variables)
        self.needCacheVariables = false
    }
    
    /// Calculate math expression which was pass via 'expression' property.
    /// - returns: NSDecimalNumber instance which contains result.
    /// - throws: If expression contains mistakes, will be throw CalculatorError error.
    open func eval() throws -> NSDecimalNumber {
        self.resetTokensStuff()
        
        var result: NSDecimalNumber? = nil
        
        try getToken()
        try eval0(&result)
        
        if  tokenType == .delimiter { // incorrect used delimiter
            try handleDelimiterAtomCase()
        }
        
        guard let finalResult = result else { throw CalculatorError.emptyExpression}
        
        return finalResult
    }
    
    // MARK:- init
    public init(expression: String) {
        self.expression = expression
    }
    
    public init(){ }
    
    deinit {
        cacheVariablesIfNeeded()
    }
    
    
    
    // MARK:- implimetantion, private section
    
    fileprivate enum TokenType {
        case delimiter
        case number
        case constVariable
        case variable
        case function
        case none     // none type
    }
    
    fileprivate var token = ""
    fileprivate var tokenType = TokenType.none
    fileprivate var index = 0
 
    fileprivate func resetTokensStuff() {
        self.cacheVariablesIfNeeded()
        token = ""
        tokenType = .none
        index = 0
    }
    fileprivate var needCacheVariables = false
    
    fileprivate var openBracketsStack = Stack<Bool>()
    fileprivate var insideFunctionStack = Stack<Bool>()

    
    fileprivate var endOfExpresion : Int {
        return expression.length
    }
    
    fileprivate func getToken() throws {
        token = ""
        tokenType = .none
        
        if index == endOfExpresion {
            return
        }
        var currentSumbol = expression[index]
        
        while currentSumbol == " "
        {
            index += 1
            if index == endOfExpresion
            {
                return
            }
            currentSumbol = expression[index]
        }
        
        //====================
        
        if currentSumbol.isDelimiter {
            token += String(currentSumbol)
            tokenType = .delimiter
            index += 1
        }
        else if currentSumbol.isDigit {
            tokenType = .number

            while currentSumbol.isDigit || currentSumbol == "." {
                token += String(currentSumbol)
                index += 1

                if index == endOfExpresion {
                    break
                }
                currentSumbol = expression[index]
            }
        }
        else if currentSumbol.isLettet || currentSumbol == "_" {
            tokenType = .variable
            
            while currentSumbol.isLettet || currentSumbol == "_" ||
            currentSumbol.isDigit {
                token += String(currentSumbol)
                index += 1
                
                if index == endOfExpresion {
                    break
                }
                currentSumbol = self.expression[index]
            }
        }
        else {
            throw CalculatorError.undefineOrIncorectUsedOfTheDelimiter(range: rangeOfToken(String(currentSumbol), index: index+1))
        }
        
        let paternForNumber = "(?<=^| )\\d+(\\.\\d+)?(?=$| )" // only case like 1 or 1.2
        if tokenType == .number && !(token =~ paternForNumber) {
            throw CalculatorError.wrongFormatOfNumber(range: rangeOfCurrentToken)
        }
        
        if tokenType == .variable {
            if isTokenConstVariable {
                tokenType = .constVariable
            }
            else if isTokenFunction {
                tokenType = .function
            }
        }
    }
    // MARK:- calculate methods
    fileprivate func eval0(_ result: inout NSDecimalNumber?) throws {
        if tokenType == .variable {
            let tempToken = token
            try getToken()
            
            if token != "=" {
                index = 0 // move to start
                try getToken()
            }
            else {
               try getToken()
               try eval1(&result)
                
                if result != nil {
                    variables[tempToken] = result!
                    needCacheVariables = true;
                }
                return
            }
        }
        
        try eval1(&result)
    }
    fileprivate func eval1(_ result: inout NSDecimalNumber?) throws {
        try eval2(&result)
        
        var op = token
        var indexOfOp = index
        
        while op == "+" || op == "-" {
            try getToken()
            
            var tempValue: NSDecimalNumber?
            try eval2(&tempValue)
            
            guard let firstOperand = result else { return }
            guard let secondOperand = tempValue else {
                throw CalculatorError.missingArgument(range: rangeOfToken(op, index: indexOfOp))
            }
            
            switch op {
            case "+":
                result = firstOperand + secondOperand
            case "-":
                result = firstOperand - secondOperand
            default:
                break;
            }

            op = token
            indexOfOp = index
        }
    }
    
    fileprivate func eval2(_ result: inout NSDecimalNumber?) throws {
        try eval3(&result)
        
        var op = token
        var indexOfOp = index
        
        while op == "*" || op == "/" {
            try getToken()
            
            var tempValue: NSDecimalNumber?
            try eval3(&tempValue)
            
            guard let firstOperand = result else { return }
            guard let secondOperand = tempValue else {
                throw CalculatorError.missingArgument(range: rangeOfToken(op, index: indexOfOp))
            }
            
            switch op {
            case "*":
                result = firstOperand * secondOperand
            case "/":
                if secondOperand == NSDecimalNumber(string: "0") { // div by zero case
                    throw CalculatorError.divByZero(range: rangeOfToken(op, index: indexOfOp))
                }
                else {
                    result = firstOperand / secondOperand
                }
            default:
                break;
            }
            
            op = token
            indexOfOp = index
        }
    }
    
    fileprivate func eval3(_ result: inout NSDecimalNumber?) throws {
        try eval4(&result)
        
        let indexOfDelimiter = index
        
        if token == "^" {
            try getToken()
            
            var tempValue: NSDecimalNumber? = nil
            try eval3(&tempValue)
            
            guard let firstOperand = result else { return }
            guard let secondOperand = tempValue else {
                throw CalculatorError.missingArgument(range: rangeOfToken("^", index: indexOfDelimiter))
            }
            
            result = firstOperand ^ secondOperand
        }
    }
    
    fileprivate func eval4(_ result: inout NSDecimalNumber?) throws {
        try eval5(&result)
        
        while token == "!" {
            guard let singleOperand = result else { return }
            
            if let factorialResult = singleOperand^! {
                result = factorialResult
            }
            else {
                throw CalculatorError.factorialFromNegativeNumber(range: self.rangeOfCurrentToken)
            }
            try getToken()
        }
    }
    
    fileprivate func eval5(_ result: inout NSDecimalNumber?) throws {
        var op = ""
        
        if token == "+" || token == "-" { // unarry + or -
            op = token
            try getToken()
        }
        
        try eval6(&result)
        
        if let singleOperand = result, op == "-" {
            result = -singleOperand
        }
    }
    
    fileprivate func eval6(_ result: inout NSDecimalNumber?) throws {
        guard tokenType == .function else {
            try eval7(&result)
            return
        }
        
        let function = token
        let indexOfFunction = index
        
        try getToken()
        
        if token != "(" {
            throw CalculatorError.missingOpenedBracket(range: rangeOfToken(function, index: indexOfFunction))
        }
        openBracketsStack.push(true)
        insideFunctionStack.push(true)
        
        let params = try getParametersForFuction(function, atIndex: indexOfFunction)
        
        if token != ")" {
            throw CalculatorError.missingClosedBracket(range: rangeOfToken(function + "(", index: indexOfFunction))
        }
        
        _ = openBracketsStack.pop()
        _ = insideFunctionStack.pop()
        
        guard let delegate = self.delegate else {
            throw CalculatorError.failedComputedOfFunction(range: rangeOfToken(function, index: indexOfFunction))
        }
        
        do {
            result = try delegate.calculateForCalculator(self, function: function, params: params)
        } catch {
            throw CalculatorError.failedComputedOfFunction(range: rangeOfToken(function, index: indexOfFunction))
        }
        
        try getToken()
    }
    
    fileprivate func eval7(_ result: inout NSDecimalNumber?) throws {
        if token == "(" {
            let indexOfOpenBracket = index
            
            openBracketsStack.push(true)
            
            try getToken()
            try eval1(&result)
            
            if token != ")" {
                throw CalculatorError.missingClosedBracket(range: rangeOfToken("(", index: indexOfOpenBracket))
            }
            _ = openBracketsStack.pop()
            
            try getToken()
        }
        else {
            try atom(&result)
        }
    }
    
    fileprivate func atom(_ result: inout NSDecimalNumber?) throws {
        switch(tokenType) {
        case .number:
            result = NSDecimalNumber(string: token)
            try getToken()
        case .constVariable:
            result = self.dataSource?.constantVariables(self)[token]
            try getToken()
        case .variable:
            if let variable = variables[token] {
                result = variable
                try getToken()
            }
            else {
                throw CalculatorError.undefinedVariable(range: self.rangeOfCurrentToken)
            }
        case .delimiter:
            try handleDelimiterAtomCase()
        default:
            break
        }
    }
    
    fileprivate func getParametersForFuction(_ function: String, atIndex index: Int) throws -> [NSDecimalNumber] {
        var result = [NSDecimalNumber]()
        
        repeat {
            var parameter: NSDecimalNumber? = nil
            
            try getToken()
            try eval1(&parameter)
            
            if let parameter = parameter {
                result.append(parameter)
            } else {
                throw CalculatorError.missingArgument(range: self.rangeOfToken(function, index: index))
            }
        
        } while token == ","
        
        return result
    }
    
    
    // MARK:- supported methods
    fileprivate func handleDelimiterAtomCase() throws {
        switch(token) {
        case ")" where !openBracketsStack.isEmpty:
            break
        case "," where !insideFunctionStack.isEmpty:
            break
        case ")": // closed bracket without open bracket
            throw CalculatorError.missingOpenedBracket(range: self.rangeOfCurrentToken)
        default:
            throw CalculatorError.undefineOrIncorectUsedOfTheDelimiter(range: self.rangeOfCurrentToken)
        }
    }
    fileprivate var isTokenConstVariable: Bool {
        if let constVariables = self.dataSource?.constantVariables(self) {
            return constVariables[self.token] != nil
        }
        return false
    }
    
    fileprivate var isTokenFunction: Bool {
        if let functions = self.dataSource?.functions(self) {
            return functions.contains(token)
        }
        return false
    }
    
    fileprivate func rangeOfToken(_ token: String, index: Int) -> CountableRange<Int> {
        let distance = token.length
        let location =  index - (distance)
        
        return location..<location + distance
    }
    
    fileprivate var rangeOfCurrentToken: CountableRange<Int> {
        return rangeOfToken(token, index: index)
    }
}
