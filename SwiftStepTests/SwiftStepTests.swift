//
//  SwiftStepTests.swift
//  SwiftStepTests
//
//  Created by rukesh on 7/29/14.
//  Copyright (c) 2014 Rukesh. All rights reserved.
//

import UIKit
import XCTest
import SwiftStep


class SwiftStepTests: XCTestCase {
    
    override func setUp() {
        var myModel = SwiftStepDataModel()
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    func testMakeOneDay(){
       var model = SwiftStepDataModel()
        let today = NSDate()
        let interval = makeOneDay
    }
    
    }
