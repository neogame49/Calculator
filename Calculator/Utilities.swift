

import Foundation

// MARK:- Character utilities
 public extension Character {
    var isDigit: Bool {
            let validationSet = CharacterSet.decimalDigits
            return validationSet.isSuperset(of: CharacterSet(charactersIn: String(self)))
    }
    
    var isDelimiter: Bool {
            let valiidDelimiters = "+-*/!()=^,"
            let validationSet = CharacterSet(charactersIn: valiidDelimiters)
        return validationSet.isSuperset(of: CharacterSet(charactersIn: String(self)))
    }
    
    var isLettet: Bool {
        let validationSet = CharacterSet.letters
        
        return validationSet.isSuperset(of: CharacterSet(charactersIn: String(self)))
    }
}

// MARK:- String utilities
public extension String {
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
}

precedencegroup ComparisonPrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
}

infix operator =~ : ComparisonPrecedence

func =~ (string: String, patern: String) -> Bool {
    let regExp = try? NSRegularExpression(pattern: patern, options: .caseInsensitive)
    
    if let correctRegExp = regExp {
        let matches = correctRegExp.matches(in: string, options: [], range:
            NSMakeRange(0,string.length))
        
        return matches.count > 0
    }
    else {
        return false
    }
}

// MARK:- NSDecimalNumber override operators

precedencegroup DefaultPrecedence {
    associativity: left
    higherThan: MultiplicationPrecedence
}

infix   operator ^ : DefaultPrecedence

postfix operator ^!

func + (firstValue: NSDecimalNumber, secondValue: NSDecimalNumber) -> NSDecimalNumber {
    return firstValue.adding(secondValue)
}

func - (firstValue: NSDecimalNumber, secondValue: NSDecimalNumber) -> NSDecimalNumber {
    return firstValue.subtracting(secondValue)
}

func * (firstValue: NSDecimalNumber, secondValue: NSDecimalNumber) -> NSDecimalNumber {
    return firstValue.multiplying(by: secondValue)
}

func / (firstValue: NSDecimalNumber, secondValue: NSDecimalNumber) -> NSDecimalNumber {
    return firstValue.dividing(by: secondValue)
}

prefix func - (value: NSDecimalNumber) -> NSDecimalNumber {
    return value * NSDecimalNumber(value: -1 as Int)
}

func == (firstValue: NSDecimalNumber, secondValue: NSDecimalNumber) -> Bool {
    return firstValue.description == secondValue.description
}

func != (firstValue: NSDecimalNumber, secondValue: NSDecimalNumber) -> Bool {
    return !(firstValue == secondValue)
}

func ^ (firstValue: NSDecimalNumber, secondValue: NSDecimalNumber) -> NSDecimalNumber {
    return NSDecimalNumber(value: pow(firstValue.doubleValue, secondValue.doubleValue) as Double)
}

/// Comput factorial of value.
// Truncates the fractional part if need.
// If value is negtive number return nil.
public postfix func ^! (value: NSDecimalNumber) -> NSDecimalNumber? {
    let intValue = value.intValue
    if intValue >= 0 {
        let result = factorial(intValue)
        return NSDecimalNumber(value: result as Int)
    }
    else { // negative number
        return nil
    }
}

// MARK:- supported func
private func factorial(_ value: Int) -> Int {
    return value == 0 ? 1 : value * factorial(value - 1)
}

// MARK:- string extension
extension String {
    var length: Int {
        return self.count
    }
}
