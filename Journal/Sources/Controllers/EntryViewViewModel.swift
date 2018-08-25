//
//  EntryViewViewModel.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 8. 25..
//  Copyright © 2018년 roe. All rights reserved.
//

import UIKit

protocol EntryViewViewModelDelegate: class {
    func didAddEntry(_ entry: EntryType)
    func didRemoveEntry(_ entry: EntryType)
}

class EntryViewViewModel {
    
    weak var delegate: EntryViewViewModelDelegate?
    
    private let environment: Environment
    private var entry: EntryType?
    init(environment: Environment, entry: EntryType? = nil) {
        self.environment = environment
        self.entry = entry
    }
    var hasEntry: Bool { return entry != nil }
    var trashIconEnabled: Bool { return hasEntry }
    var title: String {
        let date = entry?.createdAt ?? environment.now()
        let df = DateFormatter.formatter(with: environment.settings.dateFormat.rawValue)
        return df.string(from: date)
    }
    var textViewFont: UIFont {
        return UIFont.systemFont(ofSize: environment.settings.fontSize.rawValue)
    }
    
    var textViewText: String? { return entry?.text }
    private(set) var isEditing: Bool = false
    var textViewEditable: Bool { return isEditing }
    var buttonImage: UIImage { return isEditing ? #imageLiteral(resourceName: "baseline_save_white_24pt") : #imageLiteral(resourceName: "baseline_edit_white_24pt") }
    func startEditing() {
        isEditing = true
    }
    func completeEditing(with text: String) {
        if var oldEntry = self.entry {
            oldEntry.text = text
            environment.entryRepository.update(oldEntry)
        } else {
            let newEntry: EntryType = environment.entryFactory(text)
            environment.entryRepository.add(newEntry)
            delegate?.didAddEntry(newEntry)
            entry = newEntry
        }
        isEditing = false
    }
    func removeEntry() -> EntryType? {
        guard let entryToRemove = entry else { return nil }
        self.environment.entryRepository.remove(entryToRemove)
        self.entry = nil
        self.delegate?.didRemoveEntry(entryToRemove)
        return entryToRemove
    }
    
    func testRemoveEntry() {
        // Setup
//        let mockRepo = MockEntryRepository()
//        let environment = Environment(entryRepository: mockRepo)
//        let entry = Entry(text: "제거할 일기")
//        let viewModel = EntryViewViewModel(environment: environment, entry: entry)
//        // Run
//        let removedEntry = viewModel.removeEntry()
//        // Verify
//        expect(removedEntry) == entry
//        expect(mockRepo.removedEntry) == entry
//        expect(viewModel.hasEntry) == false
    }
    
}
