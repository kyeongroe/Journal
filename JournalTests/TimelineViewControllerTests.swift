//
//  TimelineViewControllerTests.swift
//  JournalTests
//
//  Created by 김경뢰 on 2018. 8. 18..
//  Copyright © 2018년 roe. All rights reserved.
//

import XCTest
import Nimble

@testable import Journal

class TimelineViewControllerTests: XCTestCase {
    var vc: TimelineViewController!
    override func setUp() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        vc = UIStoryboard.instantiateViewController(withIdentifier: "TimelineViewController") as! TimelineViewController = vc.view // loadView()와 viewDidLoad()를 강제로 호출
    }
    func testEntryCountLabelTextWhenNoEntry() {
        // Setup
        vc.environment = Environment()
        // Run
        vc.viewWillAppear(false)
        // Verify
//        expect(self.vc.entryCountLabel.text) == "엔트리 없음"
    }
    func testEntryCountLabelTextWhenEntryExists() {
        // Setup
        let repository = InMemoryEntryRepository(entries: [Entry(id: UUID(), createdAt: Date.distantPast, text: "그저께 일기"), Entry(id: UUID(), createdAt: Date(), text: "어제 일기"), Entry(id: UUID(), createdAt: Date.distantFuture, text: "오늘 일기")])
        vc.environment = Environment(entryRepository: repository)
        // Run
        vc.viewWillAppear(false)
        // Verify
//        expect(self.vc.entryCountLabel.text) == "엔트리 수: 3"
    }
}
