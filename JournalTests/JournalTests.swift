//
//  JournalTests.swift
//  JournalTests
//
//  Created by 김경뢰 on 2018. 7. 28..
//  Copyright © 2018년 roe. All rights reserved.
//

import XCTest
import Nimble

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
        // Setup
        // Nimble
        let entry = Entry(id: 0, createdAt: Date(), text: "첫 번째 일기") // Run
        entry.text = "첫 번째 테스트"
        // Verify
        expect(entry.text).to(equal("첫 번째 테스트"))
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
        expect(entryInJournal).to(equal(newEntry))
        expect(entryInJournal?.isIdentical(to: newEntry)).to(equal(true))
    }
    
    func testGetEntryWithId() {
        // Setup
        let oldEntry = Entry(id: 1, createdAt: Date(), text: "일기")
        let journal = InMemoryJournal(entries: [oldEntry])
        // Run
        let entry = journal.entry(with: 1)
        // Verify
        expect(entry).to(equal(oldEntry))
        expect(entry?.isIdentical(to: oldEntry)).to(equal(true))
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
        expect(entry).to(equal(oldEntry))
        expect(entry?.isIdentical(to: oldEntry)).to(equal(true))
        expect(entry?.text).to(equal("일기 내용을 수정했습니다"))
    }
    
    func testRemoveEntryFromJournal() {
        // Setup
        let oldEntry = Entry(id: 1, createdAt: Date(), text: "일기")
        let journal = InMemoryJournal(entries: [oldEntry])
        // Run
        journal.remove(oldEntry)
        // Verify
        let entry = journal.entry(with: 1)
        expect(entry).to(beNil())
    }
    
    func test_최근_순으로_엔트리를_불러올_수_있다() { // Setup
        let dayBeforeYesterday = Entry(id: 1, createdAt: Date.distantPast, text: "그저께 일기")
        let yesterDay = Entry(id: 2, createdAt: Date(), text: "어제 일기")
        let today = Entry(id: 3, createdAt: Date.distantFuture, text: "오늘 일기")
        let journal = InMemoryJournal(entries: [dayBeforeYesterday, yesterDay, today])
        
        // Run
        let entries = journal.recentEntries(max: 3)
        // Verify
        expect(entries.count).to(equal(3))
        expect(entries).to(equal([today, yesterDay, dayBeforeYesterday]))
    }
    
    func test_요청한_엔트리의_수만큼_최신_순으로_반환한다() { // Setup
        let dayBeforeYesterday = Entry(id: 1, createdAt: Date.distantPast, text: "그저께 일기")
        let yesterDay = Entry(id: 2, createdAt: Date(), text: "어제 일기")
        let today = Entry(id: 3, createdAt: Date.distantFuture, text: "오늘 일기")
        let journal = InMemoryJournal(entries: [dayBeforeYesterday, yesterDay, today])
        // Run
        let entries = journal.recentEntries(max: 1)
        // Verify
        expect(entries.count).to(equal(1))
        expect(entries).to(equal([today]))
    }
    
    func test_존재하는_엔트리보다_많은_수를_요청하면_존재하는_엔트리만큼만_반환한다() { // Setup
        let dayBeforeYesterday = Entry(id: 1, createdAt: Date.distantPast, text: "그저께 일기")
        let yesterDay = Entry(id: 2, createdAt: Date(), text: "어제 일기")
        let today = Entry(id: 3, createdAt: Date.distantFuture, text: "오늘 일기")
        let journal = InMemoryJournal(entries: [dayBeforeYesterday, yesterDay, today])
        // Run
        let entries = journal.recentEntries(max: 10)
        // Verify
        expect(entries.count).to(equal(3))
        expect(entries).to(equal([today, yesterDay, dayBeforeYesterday]))
    }
    
    func test_존재하는_엔트리보다_적은_수를_요청하면_NIL_반환한다() { // Setup
        let dayBeforeYesterday = Entry(id: 1, createdAt: Date.distantPast, text: "그저께 일기")
        let yesterDay = Entry(id: 2, createdAt: Date(), text: "어제 일기")
        let today = Entry(id: 3, createdAt: Date.distantFuture, text: "오늘 일기")
        let journal = InMemoryJournal(entries: [dayBeforeYesterday, yesterDay, today])
        // Run
        let entries = journal.recentEntries(max: -1)
        // Verify
        expect(entries).to(equal([]))
    }
}
