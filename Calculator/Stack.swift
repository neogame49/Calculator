//
//  Stack.swift
//  CalculatorOnSwift
//
//  Created by Macbook on 16.02.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

import Foundation

struct Stack<T> {
    private var items = [T]()
    
    //MARK:- interface
    
    mutating func push(newItem: T) {
        items.append(newItem)
    }
    
    mutating func pop() -> T {
        return items.removeLast()
    }
    
    func top() -> T? {
        return items.last
    }
    
    mutating func removeAll() {
        items.removeAll(keepCapacity: false)
    }
    
    var count: Int {
        return items.count
    }
    
    var isEmpty: Bool {
        return items.isEmpty
    }
}
