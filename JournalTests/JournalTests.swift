//
//  JournalTests.swift
//  JournalTests
//
//  Created by 김경뢰 on 2018. 7. 28..
//  Copyright © 2018년 roe. All rights reserved.
//

import XCTest

@testable import Journal

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
        let entry = Entry(id: 1, createdAt: Date(), text: "일기")
        
        //run
        entry.text = "첫 번째 테스트"
        // Verify
        XCTAssertEqual(entry.text, "첫 번째 테스트")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAddEntryToJournal() {
        // Setup
        let journal = InMemoryJournal()
        let newEntry = Entry(id: 1, createdAt: Date(), text: "일기")
        // Run
        journal.add(newEntry)
        // Verify
        let entryInJournal: Entry? = journal.entry(with: 1)
        XCTAssertEqual(entryInJournal, .some(newEntry))
        XCTAssertTrue(entryInJournal === newEntry)
        XCTAssertTrue(entryInJournal?.isIdentical(to: newEntry) == true)
    }
    
    func testGetEntryWithId() {
        // Setup
        let oldEntry = Entry(id: 1, createdAt: Date(), text: "일기")
        let journal = InMemoryJournal(entries: [oldEntry])
        // Run
        let entry = journal.entry(with: 1)
        // Verify
        XCTAssertEqual(entry, .some(oldEntry))
        XCTAssertTrue(entry?.isIdentical(to: oldEntry) == true)
    }
    
    func testUpdateEntry() {
        // Setup
        let oldEntry = Entry(id: 1, createdAt: Date(), text: "일기")
        let journal = InMemoryJournal(entries: [oldEntry])
        // Run
        oldEntry.text = "일기 내용을 수정했습니다"
        journal.update(oldEntry)
        // Verify
        let entry = journal.entry(with: 1)
        XCTAssertEqual(entry, .some(oldEntry))
        XCTAssertTrue(entry?.isIdentical(to: oldEntry) == true)
        XCTAssertEqual(entry?.text, .some("일기 내용을 수정했습니다"))
    }
}
