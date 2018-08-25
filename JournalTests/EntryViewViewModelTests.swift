//
//  EntryViewViewModelTests.swift
//  JournalTests
//
//  Created by 김경뢰 on 2018. 8. 25..
//  Copyright © 2018년 roe. All rights reserved.
//

import XCTest
import Nimble

@testable import Journal

class EntryViewViewModelTests: XCTestCase {
    
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
    
    func testHasEntry() {
        // Setup
        let environment = Environment()
        let entry = Entry(text: "일기")
        // Run
        let entryHasViewModel = EntryViewViewModel(environment: environment, entry: entry)
        let noEntryViewModel = EntryViewViewModel(environment: environment)
        // Verify
        expect(entryHasViewModel.hasEntry) == true
        expect(noEntryViewModel.hasEntry) == false
    }
    
    func testTextViewTextReturnsEntryText() {
        // Setup
        let environment = Environment()
        let entry = Entry(text: "일기")
        // Run
        let entryHasViewModel = EntryViewViewModel(environment: environment, entry: entry)
        let noEntryViewModel = EntryViewViewModel(environment: environment)
        // Verify
        expect(entryHasViewModel.textViewText) == "일기"
        expect(noEntryViewModel.textViewText).to(beNil())
    }
    
    func testTitleWhenEntryExists() {
        // Setup
        let environment = Environment()
        let createdAt: Date = Date()
        let entry = Entry(createdAt: createdAt, text: "일기")
        // Run
        let viewModel = EntryViewViewModel(environment: environment, entry: entry)
        // Verify
        expect(viewModel.title) == DateFormatter.entryDateFormatter.string(from: createdAt)
    }
    
    func testTitleWhenEntryIsNil() {
        let now: Date = Date()
        let environment = Environment(now: { now })
        // Run
        let viewModel = EntryViewViewModel(environment: environment)
        // Verify
        expect(viewModel.title) == DateFormatter.entryDateFormatter.string(from: now)
    }
    
    func testTrashIconEnabledWhenEntryExists() { let environment = Environment()
        let entry = Entry(text: "일기")
        // Run
        let viewModel = EntryViewViewModel(environment: environment, entry: entry)
        // Verify
        expect(viewModel.trashIconEnabled) == true
    }
    
    func testTrashIconDisabledWhenEntryIsNil() {
        let environment = Environment()
        // Run
        let viewModel = EntryViewViewModel(environment: environment)
        // Verify
        expect(viewModel.trashIconEnabled) == false
    }
    
    func testUpdateOfEditingProperiesWhenStartEditing() {
        let viewModel = EntryViewViewModel(environment: Environment())
        expect(viewModel.isEditing) == false
        expect(viewModel.textViewEditable) == false
        expect(viewModel.buttonImage) == #imageLiteral(resourceName: "baseline_edit_white_24pt")
        // Run
        viewModel.startEditing()
        // Verify
        expect(viewModel.isEditing) == true
        expect(viewModel.textViewEditable) == true
        expect(viewModel.buttonImage) == #imageLiteral(resourceName: "baseline_save_white_24pt")
    }
    
    func testUpdateOfEditingPropertiesWhenCompleteEditing() {
        // Setup
        let viewModel = EntryViewViewModel(environment: Environment())
        viewModel.startEditing()
        // Run
        viewModel.completeEditing(with: "수정 끝")
        // Verify
        expect(viewModel.isEditing) == false
        expect(viewModel.textViewEditable) == false
        expect(viewModel.buttonImage) == #imageLiteral(resourceName: "baseline_edit_white_24pt")
    }
    
    func testAddEntryToRepositoryWhenEntryPropertyIsNil() {
        let viewModel = EntryViewViewModel(environment: Environment())
        // Run
        viewModel.completeEditing(with: "첫 번째 생성")
        // Verify
        expect(viewModel.hasEntry) == true
    }
    
}
