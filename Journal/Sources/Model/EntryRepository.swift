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
    func add(_ entry: Entry)
    func update(_ entry: Entry)
    func remove(_ entry: Entry)
    func entry(with id: UUID) -> Entry?
    func recentEntries(max: Int) -> [Entry]
}

class InMemoryEntryRepository: EntryRepository {
    
    private var entries: [UUID: Entry]
    
    init(entries: [Entry] = []) {
        var result: [UUID: Entry] = [:]
        entries.forEach { entry in
            result[entry.id] = entry
        }
        self.entries = result
    }
    
    var numberOfEntries: Int { return entries.count }
    
    func add(_ entry: Entry) {
        entries[entry.id] = entry
    }
    
    func update(_ entry: Entry) {
        entries[entry.id] = entry
    }
    
    func remove(_ entry: Entry) {
        entries[entry.id] = nil
    }
    
    func entry(with id: UUID) -> Entry? {
        return entries[id]
    }
    
    func recentEntries(max: Int) -> [Entry] {
        
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
