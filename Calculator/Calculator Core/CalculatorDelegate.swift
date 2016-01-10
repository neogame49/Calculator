//
//  CalculatorDelegate.swift
//  Calculator
//
//  Created by Roman on 1/3/16.
//  Copyright © 2016 Scherbiy Roman. All rights reserved.
//

public protocol CalculatorDelegate: class {
    /**
        Since you provided indentifiers for functions which can be calculated via 'functions:' method of the CalculatorDataSource. You have a opportunity to calculate the result of particular function via this method.
     
        - parameter calculator: Instance of  Calculator which called method.
        - parameter function: String indentifier of function which need to calculate.
        - parameter params: Parameters which user passed into function.
     
        - returns: Result of calculation.
     
        - throws: If you can't calculate function for some reason(wrong number of parameters, out of avalible range for particular parameter, etc), you can indicate it by throwing error. **Note: any errors throwing by this method will be reproduce in CalculatorError.FailedComputedOfFunction error.**
    */
    func calculateForCalculator(calculator: Calculator, function: String, params: [NSDecimalNumber]) throws -> NSDecimalNumber
    /**
        Calculator has feature to cache variables which user defined before(manually: via 'cacheVariablesIfNeeded' method, automatically: before deinitialization). In ala this cases
        will be invoked this method to give an opportunity to chache variables in prefer way.
     
        - parameter calculator: Instance of  Calculator which called method.
        - parameter variables: Dictionary of variables and them valus which need to chache.
     */
    func cacheVariablesForCalculator(calculator: Calculator, variables: [String: NSDecimalNumber])
}

// MARK:- Default implementation
public extension CalculatorDelegate {
    func calculateForCalculator(calculator: Calculator, function: String, params: [NSDecimalNumber])
        throws -> NSDecimalNumber {
        /* Since you provided indentifiers for functions which can be calculated via 'functions:' method of the CalculatorDataSource, but didn't implement logic for calculation them via this *method. Default implementation throws error.*/
        throw NSError(domain: "default implementation can't calculate any functions", code: 100, userInfo: nil)
    }
    // Default implementation does nothing.
    func cacheVariablesForCalculator(calculator: Calculator, variables: [String: NSDecimalNumber]) {}

}