# Calculator
***
**Calculator** is a framework that allows you to calculate mathematical expressions, are given as a string.

#### Features:
  - Binary operators + - * / ^
  - Unary operators + - !(factorial)
  - Priorities operations.
  - Custom constants and functions with single or multiple arguments
  - Available to the user to create and use custom variables
  - Error handling

  
***

# How to use
***
  1. Create an instance of Calculator
  2. Assign the expression property mathematical expression, you want to calculate
  3. Call method eval() to get the result (an instance of NSDecimalNumber) or thrown error (an instance of CalculatorError enum)

```swift
        let mathExp = getMathExp() // String type
        let calculator = Calculator()
        calculator.expression = mathExp
        
        do {
            let result = try calculator.eval()
            print(result)
            
        } catch {
            // Hanlde calculator error
        }
```

### More Examples
```swift
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
```
### Custom constants
Conform *CalculatorDataSource* protocol and implement *constantVariables(_:)* method to declare the constant names and values.

```swift
class CalculatorTest:CalculatorDataSource {
    // CalculatorDataSource
    func constantVariables(calculator: Calculator) -> [String: NSDecimalNumber] {
            return ["Pi": NSDecimalNumber(string: "3.1415926535"),
                "e": NSDecimalNumber(string: "2.7182818284")]
    }
    
    // test
    func testThere() {
        let calculator = Calculator()
        calculator.dataSource = self
        
        calculator.expression = "Pi + Pi"
        print(try! calculator.eval()) // print "6.283185307"
        
        calculator.expression = "25 + e^2"
        print(try! calculator.eval()) // print "32.38905609860964864"
    }
}
```
### Custom functions
Conform *CalculatorDataSource* protocol and implement *functions(_:)*  method to declare the function names. And conform *CalculatorDelegate* protocol and implement *calculateForCalculator(_:, function:, params:)* method to calculate your own castom function.

```swift
class CalculatorTest:CalculatorDataSource, CalculatorDelegate {
    // CalculatorDataSource
     func functions(calculator: Calculator) -> Set<String> {
            return ["sin","cos","max","min"]
    }
    
    // MARK:- CalculatorDelegate
    func calculateForCalculator(calculator: Calculator, function: String, params: [NSDecimalNumber]) throws -> NSDecimalNumber {
        switch(function)
        {
        case "sin":
            if params.count != 1
            {
                throw NSError(domain: "wrong number of argument for sin function", code: 20000, userInfo: nil)
            }
            return NSDecimalNumber(double: sin(params.first!.doubleValue))
        case "cos":
            if params.count != 1
            {
                throw NSError(domain: "wrong number of argument for cos function", code: 20000, userInfo: nil)
            }
            return NSDecimalNumber(double: cos(params.first!.doubleValue))
        case "max":
            if params.count != 2
            {
                throw NSError(domain: "wrong number of argument for max function", code: 20000, userInfo: nil)
            }
            return NSDecimalNumber(double: max(params[0].doubleValue, params[1].doubleValue))
        case "min":
            if params.count != 2
            {
                throw  NSError(domain: "wrong number of argument for min function", code: 20000, userInfo: nil)
            }
            return NSDecimalNumber(double: min(params[0].doubleValue, params[1].doubleValue))
        default:
            throw NSError(domain: "unknown \(function) function", code: 20000, userInfo: nil)
        }
    }
    
    // test
    func test() {
        let calculator = Calculator()
        calculator.dataSource = self
        calculator.delegate = self

        calculator.expression = "2 + cos(0)"
        print(try! calculator.eval()) // print "3"
        
        calculator.expression = "max(2^5, 5!) + min(23, 45/2)"
        print(try! calculator.eval()) // print "142.5"
    }

}
```

### How user can create and use custom variables
To create a variable you need to get the expression declare a variable name, then put a sign equal, then the mathematical expression: *varName = mathExp*. The variable name must begin with upper or lower letters of the alphabet or underscores. And can contain uppercase and lowercase letters of the alphabet, digits and underscores. 

You can cache variables. To do this, conform *CalculatorDelegate* protocol and implement *cacheVariablesForCalculator(_:variables:)* method. To set previously cached variables, assign it to *variables* property of Calculator instance. Note, caching method will call automatically when an instance of Calculator wiil destroy.You can call it manually using the methods of the instance *cacheVariablesIfNeeded()* and *cacheVariables()*.

```swift
class CalculatorTest: CalculatorDelegate
{
    // MARK:- CalculatorDelegate
    func cacheVariablesForCalculator(calculator: Calculator, variables: [String: NSDecimalNumber]) {
        MyCacheManager().cacheVars(variables)
    }
    // test
    func test() {
        let calculator = Calculator()
        calculator.delegate = self
        // assign previously cached variables
        calculator.variables = MyCacheManager().cachedVars()
        
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

}
```
### More about error handling
If user made a mistake in a mathematical expression, you get a trown instance of CalculatorError enum. In most cases, along with the error you get an additional instance of Range<Int> which indicate the wrong part of the expression.

```swift
        let calculator = Calculator()
        
        let mathExp = "2..2 - 2"
        calculator.expression = mathExp
        
        do {
            let _ = try calculator.eval()
        } catch CalculatorError.WrongFormatOfNumber(let errorRange) {
            // print wrong part
            let start = mathExp.startIndex.advancedBy(errorRange.startIndex)
            let end = mathExp.startIndex.advancedBy(errorRange.endIndex - 1)
            
            let wrongPart = mathExp.substringWithRange(start...end)
            print(wrongPart)
        } catch {
            // any else errors
        }
```

***
# Installation
***
The infrastructure and best practices for distributing Swift libraries are currently in flux during this beta period of Swift & Xcode. In the meantime, you can add *Calculator* as a git submodule, drag the *Calculator.xcodeproj* file into your Xcode project, and add *Calculator.framework* as a dependency for your target.
***

***
# What new in version 2.0
***
Added swift 2.0 error handling.
***

***
