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
    
    private var filteredEntries: [EntryType] = []
    
    var searchText: String? {
        didSet {
            guard let text = searchText else {
                filteredEntries = []
                return
            }
            filteredEntries = environment.entryRepository.entries(contains: text)
        }
    }
    
    var isSearching: Bool {
        return searchText?.isEmpty == false
    }
    
    var title: String {
        return "Jounal"
    }
    private var dates: [Date]
    private var entries: [EntryType] { return environment.entryRepository.allEntries }
    private func entries(for day: Date) -> [EntryType] {
        return entries.filter { $0.createdAt.hmsRemoved == day }
    }
    
    private func entry(for indexPath: IndexPath) -> EntryType {
        return isSearching
            ? filteredEntries[indexPath.row]
            : entries(for: dates[indexPath.section])[indexPath.row]
    }
    
    init(environment: Environment) {
        self.environment = environment
        self.dates = environment.entryRepository.allEntries
            .compactMap { $0.createdAt.hmsRemoved }
            .unique()
    }
    
    func numberOfRows(in section: Int) -> Int {
        let date = dates[section]
        return entries(for: date).count
    }
    
    var numberOfDates: Int { return dates.count }
    
    func headerTitle(of section: Int) -> String? {
        guard isSearching == false else { return nil }
        let df = DateFormatter.formatter(with: environment.settings.dateFormat.rawValue)
        return df.string(from: dates[section])
    }
    
    var numberOfSections: Int {
        return isSearching ? 1 : dates.count
    }
    
    func title(for section: Int) -> String {
        let date = dates[section]
        return DateFormatter.formatter(with: environment.settings.dateFormat.rawValue)
            .string(from: date)
    }
    
    func numberOfItems(of section: Int) -> Int {
        return isSearching
            ? filteredEntries.count
            : entries(for: dates[section]).count
    }
    
    func entryTableViewCellModel(for indexPath: IndexPath) -> EntryTableViewCellModel {
        return EntryTableViewCellModel(entry: entry(for: indexPath), environment: environment)
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
    
    lazy var settingsViewModel: SettingsTableViewViewModel = SettingsTableViewViewModel(environment: environment)
    
    func removeEntry(at indexPath: IndexPath) {
//        let isLastEntryInSection = numberOfItems(of: indexPath.section) == 1
//        let entryToRemove = entry(for: indexPath)
//        self.environment.entryRepository.remove(entryToRemove)
//        if isLastEntryInSection {
//            self.dates = self.dates.filter { $0 != entryToRemove.createdAt.hmsRemoved }
//        }
        
        let date = dates[indexPath.section]
        let entries = self.entries(for: date)
        let entry = entries[indexPath.row]
        environment.entryRepository.remove(entry)
        
        if entries.count == 1 {
            dates = self.dates.filter { $0 != date }
        }
    }
}

extension TimelineViewViewModel: EntryViewViewModelDelegate {
    func didAddEntry(_ entry: EntryType) {
        dates = environment.entryRepository.uniqueDates
    }
    func didRemoveEntry(_ entry: EntryType) {
        dates = environment.entryRepository.uniqueDates
    }
}

extension EntryRepository {
    var allEntries: [EntryType] {
        return recentEntries(max: numberOfEntries)
    }
    
    var uniqueDates: [Date] {
        return allEntries
            .compactMap { $0.createdAt.hmsRemoved }
            .unique()
    }
}

