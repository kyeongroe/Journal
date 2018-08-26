//
//  Journal.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 8. 4..
//  Copyright © 2018년 roe. All rights reserved.
//

import Foundation

protocol EntryRepository {
    
    var numberOfEntries: Int { get }
    func add(_ entry: EntryType)
    func update(_ entry: EntryType)
    func remove(_ entry: EntryType)
    func entry(with id: UUID) -> EntryType?
    func entries(contains string: String) -> [EntryType]
    func recentEntries(max: Int) -> [EntryType]
}

class InMemoryEntryRepository: EntryRepository {
    
    private var entries: [UUID: EntryType]
    
    init(entries: [EntryType] = []) {
        var result: [UUID: EntryType] = [:]
        entries.forEach { entry in
            result[entry.id] = entry
        }
        self.entries = result
    }
    
    var numberOfEntries: Int { return entries.count }
    
    func add(_ entry: EntryType) {
        entries[entry.id] = entry
    }
    
    func update(_ entry: EntryType) {
        entries[entry.id] = entry
    }
    
    func remove(_ entry: EntryType) {
        entries[entry.id] = nil
    }
    
    func entry(with id: UUID) -> EntryType? {
        return entries[id]
    }
    
    func entries(contains string: String) -> [EntryType] {
        return entries.values
            .filter { $0.text.contains(string) }
            .sorted { $0.createdAt > $1.createdAt  }
    }
    
    func recentEntries(max: Int) -> [EntryType] {
        
        if max < 0 {
            return [];
        }
        
        let result = entries
            .values
            .sorted { lhs, rhs in lhs.createdAt > rhs.createdAt }
            .prefix(max)
        
        return Array(result)
    }
}

extension InMemoryEntryRepository {
    static var shared: InMemoryEntryRepository = InMemoryEntryRepository()
}
