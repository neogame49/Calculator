//
//  Calculator.swift
//  CalculatorOnSwift
//
//  Created by Macbook on 07.02.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

// MARK:- Error part
public enum CalculatorError: ErrorType {
    case EmptyExpression
    /// Occurs when user passed number like '2.', '2..25' etc.
    /// Also attached range of wrong part of expression.
    case WrongFormatOfNumber(range: Range<Int>)
    /// Occurs when user missed required argument like '2+', 'max(2, )' etc.
    /// Also attached range of  part of expression before missing.
    case MissingArgument(range: Range<Int>)
    /// Occurs when user tried div by zero.
    /// Also attached range of  part of expression before missing.
    case DivByZero(range: Range<Int>)
    /// Occurs when user tried  get factorial from negative number.
    /// Also attached range of wrong part of expression.
    case FactorialFromNegativeNumber(range: Range<Int>)
    /// Occurs when user typed close bracket without opening bracket before.
    /// Also attached range of wrong part of expression.
    case MissingOpenedBracket(range: Range<Int>)
    /// Occurs when user didn't type close bracket and opened bracket before.
    /// Also attached range of wrong part of expression.
    case MissingClosedBracket(range: Range<Int>)
    /// Occurs when delegate method ... throws error during trying calculate function.
    /// Also attached range of wrong part of expression.
    case FailedComputedOfFunction(range: Range<Int>)
    /// Occurs user try use in experession undefined variable( it absent into variables array).
    /// Also attached range of wrong part of expression.
    case UndefinedVariable(range: Range<Int>)
    /// Occurs when user passed undefined delimeter or it used is incorect like '2?2', '2++25' etc.
    /// Also attached range of wrong part of expression.
    case UndefineOrIncorectUsedOfTheDelimiter(range: Range<Int>)
}

public class Calculator: NSObject
{
// MARK:- interface

    weak public var dataSource: CalculatorDataSource?
    weak public var delegate: CalculatorDelegate?
    
    public var expression = ""
    {
        didSet
        {
            resetTokensStuff()
        }
    }
    
    /// Stores user's own valiables and them values
    /// Yo migth add cached before variables before calculation
    public var variables = [String: NSDecimalNumber]()
    
    public func cacheVariablesIfNeeded()
    {
        if needCacheVariables == true
        {
            cacheVariables()
        }
    }
    public func cacheVariables()
    {
        delegate?.cacheVariablesForCalculator(self, variables: self.variables)
        needCacheVariables = false
    }
    
    public func eval() throws -> NSDecimalNumber
    {
        resetTokensStuff()
        
        var result: NSDecimalNumber? = nil
        
        try getToken()
        try eval0(&result)
        
        if  tokenType == .Delimiter  // incorrect used delimiter
        {
            try handleDelimiterAtomCase()
        }
        
        if result == nil  // empty expresion case
        {
            throw CalculatorError.EmptyExpression
        }
        
        return result! // normal result without error
    }
    
    // MARK:- init
    public init(expression: String)
    {
        self.expression = expression
    }
    
    public  override init(){ }
    
    deinit
    {
        cacheVariablesIfNeeded()
    }
    
    
    
    // MARK:- implimetantion, private section
    
    private enum TokenType {
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
 
    private func resetTokensStuff()
    {
        self.cacheVariablesIfNeeded()
        token = ""
        tokenType = .None
        index = 0
    }
    private var needCacheVariables = false
    
    private var openBracketsStack = Stack<Bool>()
    private var insideFunctionStack = Stack<Bool>()

    
    private var endOfExpresion : Int
    {
        return expression.length
    }
    
    private func getToken() throws
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
            throw CalculatorError.UndefineOrIncorectUsedOfTheDelimiter(range: rangeOfToken(String(currentSumbol), index: index+1))
        }
        
        if tokenType == .Number && !(token =~ PrivateConstants.paternForNumber)
        {
            throw CalculatorError.WrongFormatOfNumber(range: rangeOfCurrentToken)

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
    private func eval0(inout result: NSDecimalNumber?) throws
    {
        if tokenType == .Variable
        {
            let tempToken = token
            try getToken()
            
            if token != "="
            {
                index = 0 // move to start
                try getToken()
            }
            else
            {
               try getToken()
               try eval1(&result)
                
                if result != nil
                {
                    variables[tempToken] = result!
                    needCacheVariables = true;
                }
                return
            }
        }
        
        try eval1(&result)
    }
    private func eval1(inout result: NSDecimalNumber?) throws
    {
        try eval2(&result)
        
        var tempValue: NSDecimalNumber?
        
        var op = token
        var indexOfOp = index
        
        while op == "+" || op == "-"
        {
            try getToken()
            tempValue = nil
            try eval2(&tempValue)
            
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
                throw CalculatorError.MissingArgument(range: rangeOfToken(op, index: indexOfOp))
            }
            op = token
            indexOfOp = index
        }
        
    }
    
    private func eval2(inout result: NSDecimalNumber?) throws
    {
        try eval3(&result)
        
        var tempValue: NSDecimalNumber?
        
        var op = token
        var indexOfOp = index
        
        while op == "*" || op == "/"
        {
            try getToken()
            tempValue = nil
            try eval3(&tempValue)
            
            if result != nil && tempValue != nil
            {
                switch(op)
                {
                case "*":
                    result = result! * tempValue!
                case "/":
                    if tempValue == NSDecimalNumber(string: "0") // div by zero case
                    {
                        throw CalculatorError.DivByZero(range: rangeOfToken(op, index: indexOfOp))
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
                throw CalculatorError.MissingArgument(range: rangeOfToken(op, index: indexOfOp))
            }
            
            op = token
            indexOfOp = index
        }
    }
    
    private func eval3(inout result: NSDecimalNumber?) throws
    {
        try eval4(&result)
        
        var tempValue: NSDecimalNumber? = nil
        
        let indexOfDelimiter = index
        
        if token == "^"
        {
            try getToken()
            try eval3(&tempValue)
            
            if result != nil && tempValue != nil
            {
               result = result! ^ tempValue!
            }
            else if tempValue == nil // missing second argument
            {
                throw CalculatorError.MissingArgument(range: rangeOfToken("^", index: indexOfDelimiter))
            }
        }
    }
    
    private func eval4(inout result: NSDecimalNumber?) throws
    {
        try eval5(&result)
        
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
                    throw CalculatorError.FactorialFromNegativeNumber(range: self.rangeOfCurrentToken)
                }
                
                try getToken()
            }
        }
    }
    
    private func eval5(inout result: NSDecimalNumber?) throws
    {
        var op = ""
        
        if token == "+" || token == "-" // unarry + or -
        {
            op = token
            try getToken()
        }
        
        try eval6(&result)
        
        if op == "-"
        {
            if result != nil
            {
                result = -(result!)
            }
        }
    }
    
    private func eval6(inout result: NSDecimalNumber?) throws
    {
        if tokenType == .Function
        {
            let function = token
            let indexOfFunction = index
            
            try getToken()
            
            if token != "("
            {
                throw CalculatorError.MissingOpenedBracket(range: rangeOfToken(function, index: indexOfFunction))
            }
            openBracketsStack.push(true)
            insideFunctionStack.push(true)
            
            let params = try getParametersForFuction(function, atIndex: indexOfFunction)
            
            if token != ")"
            {
                CalculatorError.MissingClosedBracket(range: rangeOfToken(function + "(", index: indexOfFunction))
            }
            
            openBracketsStack.pop()
            insideFunctionStack.pop()
            
            guard let delegate = self.delegate else {
                throw CalculatorError.FailedComputedOfFunction(range: rangeOfToken(function, index: indexOfFunction))
            }
            
            do {
              result = try delegate.calculateForCalculator(self, function: function, params: params)
            } catch {
               throw CalculatorError.FailedComputedOfFunction(range: rangeOfToken(function, index: indexOfFunction))
            }
            
            try getToken()
        }
        else
        {
            try eval7(&result)
        }
    }
    
    private func eval7(inout result: NSDecimalNumber?) throws
    {
        if token == "("
        {
            let indexOfOpenBracket = index
            
            openBracketsStack.push(true)
            
            try getToken()
            try eval1(&result)
            
            if token != ")"
            {
                throw CalculatorError.MissingClosedBracket(range: rangeOfToken("(", index: indexOfOpenBracket))
            }
            openBracketsStack.pop()
            
            try getToken()
        }
        else
        {
            try atom(&result)
        }
    }
    
    private func atom(inout result: NSDecimalNumber?) throws
    {
        switch(tokenType)
        {
        case .Number:
            result = NSDecimalNumber(string: token)
            try getToken()
        case .ConstVariable:
            result = self.dataSource?.constantVariables(self)[token]
            try getToken()
        case .Variable:
            if let variable = variables[token]
            {
                result = variable
                try getToken()
            }
            else
            {
                throw CalculatorError.UndefinedVariable(range: self.rangeOfCurrentToken)
            }
        case .Delimiter:
            try handleDelimiterAtomCase()
        case .Error:
            result = nil
        default:
            break
        }
    }
    
    private func getParametersForFuction(function: String, atIndex index: Int) throws -> [NSDecimalNumber]
    {
        var result = [NSDecimalNumber]()
        
        repeat
        {
            var parameter: NSDecimalNumber? = nil
            
            try getToken()
            try eval1(&parameter)
            
            if parameter != nil
            {
                result.append(parameter!)
            }
            else
            {
                throw CalculatorError.MissingArgument(range: self.rangeOfToken(function, index: index))
            }
        
        }while token == ","
        
        return result
    }
    
    
    // MARK:- supported methods
    private func handleDelimiterAtomCase() throws {
        switch(token) {
        case ")" where !openBracketsStack.isEmpty:
            break
        case "," where !insideFunctionStack.isEmpty:
            break
        case ")": // closed bracket without open bracket
            throw CalculatorError.MissingOpenedBracket(range: self.rangeOfCurrentToken)
        default:
            throw CalculatorError.UndefineOrIncorectUsedOfTheDelimiter(range: self.rangeOfCurrentToken)
        }
    }
    private var isTokenConstVariable: Bool {
        if let constVariables = self.dataSource?.constantVariables(self) {
            return constVariables[self.token] != nil
        }
        return false
    }
    
    private var isTokenFunction: Bool
    {
        if let functions = self.dataSource?.functions(self) {
            return functions.contains(token)
        }
        return false
    }
    
    private func rangeOfToken(token: String, index: Int) -> Range<Int>
    {
        let distance = token.length
        let location =  index - (distance)
        
        return location..<location + distance
        //return NSMakeRange(location, distance)
    }
    
    private var rangeOfCurrentToken: Range<Int>
    {
        return rangeOfToken(token, index: index)
    }
}
