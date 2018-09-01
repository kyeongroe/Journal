//
//  FirebaseEntryRepository.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 9. 1..
//  Copyright © 2018년 roe. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseEntryRepository: EntryRepository {
    private let reference: DatabaseReference
    
    private var oldestEntryCreatedAt: Double?
    
    init(reference: DatabaseReference = Database.database().reference()) {
        self.reference = reference.child("entries")
    }
    
    var numberOfEntries: Int { return 0 }
    
    func add(_ entry: EntryType) {
        guard let entry = entry as? Entry else { fatalError() }
        reference.child(entry.id.uuidString).setValue(entry.toDitionary())
    }
    
    func update(_ entry: EntryType) { }
    func remove(_ entry: EntryType) { }
   
    func entry(with id: UUID) -> EntryType? {
        return nil
    }
    
    func entries(contains string: String, completion: @escaping ([EntryType]) -> Void) {
        self.reference
            .queryOrdered(byChild: "text")
            .queryStarting(atValue: string)
            .queryEnding(atValue: string + "\u{f8ff}")
            .observeSingleEvent(of: .value) { snapshot in
                let entries: [Entry] = snapshot.children.compactMap {
                    guard
                        let childSnapshot = $0 as? DataSnapshot,
                        let dict = childSnapshot.value as? [String: Any],
                        let entry = Entry(dictionary: dict)
                        else { return nil }
                    return entry
                }
                completion(entries)
        }
    }
    
    func recentEntries(max: Int, page: Int, completion: @escaping ([EntryType], Bool) -> Void) {
        if page == 0 { oldestEntryCreatedAt = nil }
        
        var query = self.reference
            .queryOrdered(byChild: "createdAt")
        if let endAt = oldestEntryCreatedAt {
            query = query.queryEnding(atValue: endAt - 0.000001, childKey: "createdAt")
        }
        
        query
            .queryLimited(toLast: UInt(max))
            .observeSingleEvent(of: .value) { snapshot in
                
//                print(snapshot)
                
                let entries: [Entry] = snapshot.children.compactMap {
                    guard
                        let childSnapshot = $0 as? DataSnapshot,
                        let dict = childSnapshot.value as? [String: Any],
                        let entry = Entry(dictionary: dict)
                        else { return nil }
                    return entry
                }.reversed()
                
//                print(entries)
                
                self.oldestEntryCreatedAt = entries.last?.createdAt.timeIntervalSince1970
                let isLastPage = entries.count < max
                completion(entries, isLastPage)
            }
    }
}
