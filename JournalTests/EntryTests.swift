//
//  EntryTests.swift
//  JournalTests
//
//  Created by 김경뢰 on 2018. 8. 7..
//  Copyright © 2018년 roe. All rights reserved.
//

import XCTest

import Nimble

@testable import Journal

class EntryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testBasicEntryType() {
        let entry: Entry = Entry(id: UUID(), createdAt: Date(), text: "첫 번째 일기") // Run
        entry.text = "첫 번째 테스트"
        // Verify
        expect(entry.text).to(equal("첫 번째 테스트"))
    }
    
}
