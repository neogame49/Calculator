//
//  CalculatorDataSource.swift
//  Calculator
//
//  Created by Roman on 1/2/16.
//  Copyright © 2016 Scherbiy Roman. All rights reserved.
//

public protocol CalculatorDataSource: class {
    /// Returns constant variable names with associated NSDecimalNumber values( for example Pi : 3.14).
    /// **Note: user can't use already reserved const variable names( in this case will be throw a error).**
    func constantVariables(calculator: Calculator) -> [String: NSDecimalNumber]
    /// Returns string identifiers for functions which are allowed to calculate.
    /// **Note: to have opportunity to caclulate this function, you need implement the 'calculateForCalculator function: params:' method in the CalculatorDelegate.**
    func functions(calculator: Calculator) -> Set<String>
}

// MARK:- Default implementation
public extension CalculatorDataSource {
    func constantVariables(calculator: Calculator) -> [String: NSDecimalNumber] {
        return [:]
    }
    
    func functions(calculator: Calculator) -> Set<String> {
        return []
    }
}