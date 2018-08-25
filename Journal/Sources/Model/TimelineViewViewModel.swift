//
//  TimelineViewModel.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 8. 25..
//  Copyright © 2018년 roe. All rights reserved.
//

import Foundation

class TimelineViewViewModel {

    let environment: Environment
    
    var title: String {
        return "Jounal"
    }
    private var dates: [Date]
    private var entries: [Entry] { return environment.entryRepository.allEntries }
    private func entries(for day: Date) -> [Entry] {
        return entries.filter { $0.createdAt.hmsRemoved == day }
    }
    private func entry(for indexPath: IndexPath) -> Entry {
        return entries(for: dates[indexPath.section])[indexPath.row]
    }
    init(environment: Environment) {
        self.environment = environment
        self.dates = environment.entryRepository.allEntries
            .compactMap { $0.createdAt.hmsRemoved }
            .unique()
    }
    
    var numberOfDates: Int { return dates.count }
    func headerTitle(of section: Int) -> String {
        return DateFormatter.entryDateFormatter.string(from: dates[section])
    }
    func numberOfItems(of section: Int) -> Int {
        return entries(for: dates[section]).count
    }
    
    func entryTableViewCellModel(for indexPath: IndexPath) -> EntryTableViewCellViewModel {
        let entry = self.entry(for: indexPath)
        return EntryTableViewCellViewModel(entry: entry)
    }
    
    func newEntryViewViewModel() -> EntryViewViewModel {
        let entryVM = EntryViewViewModel(environment: environment)
        entryVM.delegate = self
        return entryVM
    }
    func entryViewModel(for indexPath: IndexPath) -> EntryViewViewModel {
        let entryVM = EntryViewViewModel(environment: environment, entry: entry(for: indexPath))
        entryVM.delegate = self
        return entryVM
    }
    
    func removeEntry(at indexPath: IndexPath) {
        let isLastEntryInSection = numberOfItems(of: indexPath.section) == 1
        let entryToRemove = entry(for: indexPath)
        self.environment.entryRepository.remove(entryToRemove)
        if isLastEntryInSection { self.dates = self.dates.filter { $0 != entryToRemove.createdAt.hmsRemoved } }
    }
}

extension TimelineViewViewModel: EntryViewViewModelDelegate {
    func didAddEntry(_ entry: Entry) {
        dates = environment.entryRepository.uniqueDates
    }
    func didRemoveEntry(_ entry: Entry) {
        dates = environment.entryRepository.uniqueDates
    }
}

extension EntryRepository {
    var allEntries: [Entry] {
        return recentEntries(max: numberOfEntries)
    }
    
    var uniqueDates: [Date] {
        return allEntries
            .compactMap { $0.createdAt.hmsRemoved }
            .unique()
    }
}

