//
//  FormatTests.swift
//  CapitalAdvisor
//
//  Created by Alex Antipov on 04/10/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

//@testable import ValueFormat

@testable import CapitalAdvisor

import UIKit
import XCTest

class FormatTests: XCTestCase {
    
    func testDoubleToStringConversion() {
        XCTAssertEqual(5.75.convertedToString, "5.75")
        XCTAssertEqual(2.convertedToString, "2")
        XCTAssertEqual(0.convertedToString, "0")
        XCTAssertEqual((-5.99).convertedToString, "-5.99")
        XCTAssertEqual(1000000.convertedToString, "1000000")
    }
    
    func testStringToDoubleConversion() {
        XCTAssertEqual("5.75".convertedToDouble, 5.75)
        XCTAssertEqual("2".convertedToDouble, 2)
        XCTAssertEqual("0".convertedToDouble, 0)
        XCTAssertEqual("-5.99".convertedToDouble, -5.99)
        XCTAssertEqual("1000000".convertedToDouble, 1000000)
    }
    
    func testDateToStringConversion() {
        let myDateString = "2015-09-04"
        let mydateFormatter = NSDateFormatter()
        mydateFormatter.dateFormat = "yyyy-MM-dd"
        let date = mydateFormatter.dateFromString(myDateString)
        XCTAssertEqual(date!.convertedToString, "04.09.2015")
    }
    
    func testStringToDateConversion() {
        let date1:NSDate = "04.09.2015".convertedToDate!
        
        let myDateString = "2015-09-04"
        let mydateFormatter = NSDateFormatter()
        mydateFormatter.dateFormat = "yyyy-MM-dd"
        let date2 = mydateFormatter.dateFromString(myDateString)
        XCTAssertEqual(date1, date2)
    }
    
}
