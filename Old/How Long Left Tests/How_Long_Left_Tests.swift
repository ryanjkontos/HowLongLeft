//
//  How_Long_Left_Tests.swift
//  How Long Left Tests
//
//  Created by Ryan Kontos on 5/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import XCTest

class How_Long_Left_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSupportsAlwaysOn() throws {
        
        let data: [String:Bool] = [
        
            
            "Watch1,1" : false,
            "Watch2,6" : false,
            "Watch3,2" : false,
            "Watch5,9" : false,
            
            "Watch5,3" : true,
            "Watch6,9" : true,
            "Watch6,3" : true,
            
        ]
        
        
        let model = WatchModel()
        
        for item in data {
            
            // print("Test: \(item)")
            
            let result = model.supportsAlwaysOn(modelString: item.key)
            
            XCTAssert(result == item.value, "Result for \(item.key) was \(result), expected \(item.value)")
            
        }
        
        
        
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
