//
//  RealmEntryRepository.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 8. 25..
//  Copyright © 2018년 roe. All rights reserved.
//

import Foundation
import RealmSwift

class RealmEntryRepository: EntryRepository {
    private let realm: Realm
    init(realm: Realm) {
        self.realm = realm
    }
    var numberOfEntries: Int {
        return realm.objects(RealmEntry.self).count
    }
    func add(_ entry: EntryType) {
        guard let realmEntry = entry as? RealmEntry else { fatalError() }
        try! realm.write {
            realm.add(realmEntry)
        }
    }
    func update(_ entry: EntryType) {
        guard let realmEntry = entry as? RealmEntry else { fatalError() }
        try! realm.write {
            realm.add(realmEntry, update: true)
        }
    }
    func remove(_ entry: EntryType) {
        guard let realmEntry = entry as? RealmEntry else { fatalError() }
        try! realm.write {
            realm.delete(realmEntry)
        }
    }
    
    func entry(with id: UUID) -> EntryType? {
        return realm.objects(RealmEntry.self)
            .filter("uuidString == '\(id.uuidString)'")
            .first
    }
    
    func entries(contains string: String) -> [EntryType] {
        let results = realm.objects(RealmEntry.self)
            .filter("text CONTAINS[c] '\(string)'")
            .sorted(byKeyPath: "createdAt", ascending: false)
        return Array(results)
    }
    
    func recentEntries(max: Int) -> [EntryType] {
        let results = realm.objects(RealmEntry.self)
            .sorted(byKeyPath: "createdAt", ascending: false)
            .prefix(max)
        return Array(results)
    }
}
