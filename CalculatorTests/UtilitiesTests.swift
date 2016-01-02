//
//  UtilitiesTests.swift
//  CalculatorOnSwift
//
//  Created by Macbook on 19.02.15.
//  Copyright (c) 2015 Scherbiy Roman. All rights reserved.
//

import Foundation
import XCTest



// MARK:- Character Utilities test
class CharacterUtilitiesTest: XCTestCase
{
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK:- isLetter cases
    func testIsLatterUpperACase()
    {
        let upperACharacter: Character = "A"
        
        XCTAssert(upperACharacter.isLettet, "Fail A letter case")
    }
    
    func testIsLatterLowerACase()
    {
        let lowerACharacter: Character = "a"
        
        XCTAssert(lowerACharacter.isLettet, "Fail a letter case")
    }
    
    func testIsLatterUpperZCase()
    {
        let upperZCharacter: Character = "Z"
        
        XCTAssert(upperZCharacter.isLettet, "Fail Z letter case")
    }
    
    func testIsLatterLowerZCase()
    {
        let lowerZCharacter: Character = "z"
        
        XCTAssert(lowerZCharacter.isLettet, "Fail z letter case")
    }
    func testNonLetterCase()
    {
        let nonLetter: Character = "4"
        
        XCTAssert(!nonLetter.isLettet, "Fail non letter case")
        
    }
    
    // MARK:- isDigit case
    
    func testIsDigitZeroCase()
    {
        let zeroCharacter: Character = "0"
        
        XCTAssert(zeroCharacter.isDigit, "Fail 0 digit case")
        
    }
    func testIsDigitNineCase()
    {
        let nineCharacter: Character = "9"
        
        XCTAssert(nineCharacter.isDigit, "Fail 9 digit case")
        
    }
    
    func testNonDigitCase()
    {
        let nonDigit: Character = "g"
        
        XCTAssert(!nonDigit.isDigit, "Fail non digit case")
        
    }
    // MARK:- isDelimiter case
    func testDelimiterPlusCase()
    {
        let currentDelimiter: Character = "+"
        
        XCTAssert(currentDelimiter.isDelimiter, "Fail + delimiter case")
        
    }
    
    func testDelimiterEqualCase()
    {
        let currentDelimiter: Character = "="
        
        XCTAssert(currentDelimiter.isDelimiter, "Fail = delimiter case")
        
    }
    
    func testNonValidDelimiterCase()
    {
        let nonValidDelimiter: Character = "@"
        
        XCTAssert(!nonValidDelimiter.isDelimiter, "Fail non valid delimiter delimiter case")
        
    }
    
    func testNonDelimiterCase()
    {
        let nonDelimiter: Character = "g"
        
        XCTAssert(!nonDelimiter.isDelimiter, "Fail non  delimiter case")
        
    }
    
}