//
//  JournalTests.swift
//  JournalTests
//
//  Created by 김경뢰 on 2018. 7. 28..
//  Copyright © 2018년 roe. All rights reserved.
//

import XCTest


class Entry {
    
    var id: String
    var title: String
    var contents: String
    var creator: String = "Cool Roe"
    
    let created_dt: Date
    var updated_dt: Date
    var deleted_dt: Date?
    
    init(title: String, contents: String) {
        self.id = "using uniqueid generator"
        self.title = title
        self.contents = contents
        
        self.created_dt = Date()
        self.updated_dt = Date()
    }
    
    func update(contents: String) {
        self.contents = contents
        
        self.updated_dt = Date()
        //sync or store
    }
    
    func destroy() {
        //sync or delete
    }
    
    func viewInFullScreen() {
        
    }
    
    func viewInList() {
        
    }
}


class JournalTests: XCTestCase {
    
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
//        XCTFail("test fail")
    }
    
    func testEditEntryText() {
        //setup
        let entry = Entry(title: "첫 번째 일기 제목", contents: "첫 번째 일기")
        
        //run
        entry.contents = "첫 번째 테스트"
        // Verify
        XCTAssertEqual(entry.contents, "첫 번째 테스트")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
