# Calculator
***
**Calculator** is a framework that allows you to calculate mathematical expressions, are given as a string.

#### Features:
  - Binary operators + - * / ^
  - Unary operators + - !(factorial)
  - Priorities operations
  - Custom constants and functions with one or multiple arguments
  - Available to the user to create and use custom variables
  - Error handling

  
***

# How to use
***
  1. Create an instance of Calculator
  2. Assign the expression property mathematical expression, you want to calculate
  3. Call method eval() to get the result (an instance of NSDecimalNumber) or error (an instance of NSError)

```swift
        let mathExp = getMathExp() // String type
        let calculator = Calculator()
        calculator.expression = mathExp

        // return tuple with type (result: NSDecimalNumber?, error: NSError?)
        let response = calculator.eval()
        
        if let result = response.result
        {
            println(result)
            // do some stuff with result (NSDecimalNumber type)
        }
        else
        {
            let error = response.error!
            println(error.domain)
            // do stuff with error (NSError type)
        }
```

### More Examples
```swift
       let calculator = Calculator()
        calculator.expression = "2+2"
        println(calculator.eval().result!) // print "4"
        
        calculator.expression = "2^3 - 6*3"
        println(calculator.eval().result!) // print "-10"
        
        calculator.expression = "45 + 25/5 - 5!"
        println(calculator.eval().result!) // print "-70"
        
        calculator.expression = " (2+2)*2 + (10* -3)"
        println(calculator.eval().result!) // print "-22"
        
        calculator.expression = " 1 / 5 + 0.005"
        println(calculator.eval().result!) // print "0.205"
```
### Custom constants
Adopt *CalculatorDataSource* protocol and implement *constVariables* property ещ declare the constant names and values.

```swift
class CalculatorTest:CalculatorDataSource
{
    // CalculatorDataSource
    var constVariables: [String: NSDecimalNumber] {
            return ["Pi": NSDecimalNumber(string: "3.1415926535"),
                "e": NSDecimalNumber(string: "2.7182818284")]

    }
    // test
    func test()
    {
        let calculator = Calculator()
        calculator.dataSource = self
        
        calculator.expression = "Pi + Pi"
        println(calculator.eval().result!) // print "6.283185307"
        
        calculator.expression = "25 + e^2"
        println(calculator.eval().result!) // print "32.38905609860964864"
        
        
        
    }
}
```
### Custom functions
Adopt *CalculatorDataSource* protocol and implement *functions* property to declare the function names. And adop *CalculatorDelegate* protocol and implement *calculateForCalculator(_:  function: params: handleError:) * method to calculate your own castom function

```swift
class CalculatorTest:CalculatorDataSource, CalculatorDelegate
{
    // CalculatorDataSource
    var functions: [String] {
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

    // test
    func test()
    {
        let calculator = Calculator()
        calculator.dataSource = self
        calculator.delegate = self

        calculator.expression = "2 + cos(0)"
        println(calculator.eval().result!) // print "3"
        
        calculator.expression = "max(2^5, 5!) + min(23, 45/2)"
        println(calculator.eval().result!) // print "142.5"
        
        
        
    }
}
```

### As a user can create and use custom variables
To create a variable you need to get the expression declare a variable name, then put a sign equal, then the mathematical expression: *varName = mathExp*. The variable name must begin with upper or lower letters of the alphabet or underscores. And can contain uppercase and lowercase letters of the alphabet, digits and underscores. 

You can cache variables. To do this, adop *CalculatorDelegate* protocol and implement *cacheVariablesForCalculator(_:variables:)* method. To set previously cached variables, adopt *CalculatorDataSource* protocol and implement *variables* property. Note, caching method will call automatically when an instance of Calculator wiil destroy.You can call it manually using the methods of the instance *cacheVariablesIfNeeded()* and *cacheVariables()*.
```swift
class CalculatorTest:CalculatorDataSource, CalculatorDelegate
{
    // CalculatorDataSource
    var variables: [String: NSDecimalNumber]{
        return MyCacheManager().cachedVars()
    }

    
    // MARK:- CalculatorDelegate
    func cacheVariablesForCalculator(calculator: Calculator, variables: [String: NSDecimalNumber])
    {
        MyCacheManager().cacheVars(variables)
    }

    // test
    func test()
    {
        let calculator = Calculator()
        calculator.dataSource = self
        calculator.delegate = self
        
        calculator.expression = "a = 2"
        println(calculator.eval().result!) // print "2"
        
        calculator.expression = "b = 2 + 2"
        println(calculator.eval().result!) // print "4"
        
        calculator.expression = "c = b - a"
        println(calculator.eval().result!) // print "2"
        
        calculator.expression = " b! - c"
        println(calculator.eval().result!) // print "22"
        
        calculator.expression = "c = c^3"
        println(calculator.eval().result!) // print "8"
        
        calculator.cacheVariablesIfNeeded() // manualy cache variables
        
    } // calculator instance is destroed, variables cached automatically

}
```
### More about error handling
If user made a mistake in a mathematical expression, you get an instance of NSError with an error message. In most cases, along with the error message you get an additional instance of NSRange to indicate the wrong part of the expression.
```swift
        let calculator = Calculator()
        
        let mathExp = "2..2 - 2"
        calculator.expression = mathExp
        let response = calculator.eval()
        
        if let error = response.error
        {
            println(error.domain)
            
            if let rangeOfWrongPart =  error.userInfo?[Calculator.PublicConstants.RangeOfErrorPartExpression] as? NSRange
            {
                let wrongPart = (mathExp as NSString).substringWithRange(rangeOfWrongPart)
                println(wrongPart) // print "2..2"
            }
        }
```

***
# Installation
***
The infrastructure and best practices for distributing Swift libraries are currently in flux during this beta period of Swift & Xcode. In the meantime, you can add *Calculator* as a git submodule, drag the *Calculator.xcodeproj* file into your Xcode project, and add *Calculator.framework* as a dependency for your target.
***
