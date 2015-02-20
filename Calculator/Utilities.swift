

import Foundation

// MARK:- Character utilities
 public extension Character
{
    
    var isDigit: Bool
    {
            let validationSet = NSCharacterSet.decimalDigitCharacterSet()
            
            return validationSet.isSupersetOfSet(NSCharacterSet(charactersInString: String(self)))
    }
    
    var isDelimiter: Bool
        {
            let valiidDelimiters = "+-*/!()=^,"
            let validationSet = NSCharacterSet(charactersInString: valiidDelimiters)
            
            return validationSet.isSupersetOfSet(NSCharacterSet(charactersInString: String(self)))
    }
    
    var isLettet: Bool
    {
        let validationSet = NSCharacterSet.letterCharacterSet()
        
        return validationSet.isSupersetOfSet(NSCharacterSet(charactersInString: String(self)))
    }
    
}

// MARK:- String utilities

public extension String
{
    
    subscript (i: Int) -> Character
    {
        return self[advance(self.startIndex, i)]
    }
    
}

infix operator =~ {associativity left precedence 40}

func =~ (string: String, patern: String) -> Bool
{
    let regExp = NSRegularExpression(pattern: patern, options: .CaseInsensitive, error: nil)
    
    if let correctRegExp = regExp
    {
        let matches = correctRegExp.matchesInString(string, options: nil, range:
            NSMakeRange(0,countElements(string)))
        
        return matches.count > 0
    }
    else
    {
        return false
    }

}

// MARK:- NSDecimalNumber override operators

infix   operator ^ { associativity left precedence 140 }
postfix operator ^! {}

func + (firstValue: NSDecimalNumber, secondValue: NSDecimalNumber) -> NSDecimalNumber
{
    return firstValue.decimalNumberByAdding(secondValue)
}
func - (firstValue: NSDecimalNumber, secondValue: NSDecimalNumber) -> NSDecimalNumber
{
    return firstValue.decimalNumberBySubtracting(secondValue)
}
func * (firstValue: NSDecimalNumber, secondValue: NSDecimalNumber) -> NSDecimalNumber
{
    return firstValue.decimalNumberByMultiplyingBy(secondValue)
}
func / (firstValue: NSDecimalNumber, secondValue: NSDecimalNumber) -> NSDecimalNumber
{
    return firstValue.decimalNumberByDividingBy(secondValue)
}
prefix func - (value: NSDecimalNumber) -> NSDecimalNumber
{
    return value * NSDecimalNumber(integer: -1)
}
func == (firstValue: NSDecimalNumber, secondValue: NSDecimalNumber) -> Bool
{
    return firstValue.description == secondValue.description
}
func != (firstValue: NSDecimalNumber, secondValue: NSDecimalNumber) -> Bool
{
    return !(firstValue == secondValue)
}

func ^ (firstValue: NSDecimalNumber, secondValue: NSDecimalNumber) -> NSDecimalNumber
{
    let power = secondValue.integerValue
    //return firstValue.decimalNumberByRaisingToPower(power)
    return NSDecimalNumber(double: pow(firstValue.doubleValue, secondValue.doubleValue))
}

// comput factorial of value
// truncates the fractional part if need
// if value is negtive number return nil
public postfix func ^! (inout value: NSDecimalNumber) -> NSDecimalNumber?
{
    let intValue = value.integerValue
    if intValue >= 0
    {
        let result = factorial(intValue)
        
        return NSDecimalNumber(integer: result)
    }
    else // negative number
    {
        return nil
    }
    
}
// MARK:- supported func
private func factorial(value: Int) -> Int
{
    return value == 0 ? 1 : value * factorial(value - 1)
}