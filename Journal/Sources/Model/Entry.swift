//
//  Entry.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 7. 28..
//  Copyright © 2018년 roe. All rights reserved.
//

import Foundation

class Entry: EntryType {
    let id: UUID
    let createdAt: Date
    var text: String
    init(id: UUID = UUID(), createdAt: Date = Date(), text: String) {
        self.id = id
        self.createdAt = createdAt
        self.text = text
    }
}

extension Entry {
    convenience init?(dictionary: [String: Any]) {
        guard
            let uuidString = dictionary["uuidString"] as? String,
            let uuid = UUID(uuidString: uuidString),
            let createdAtTimeInterval = dictionary["createdAt"] as? Double,
            let text = dictionary["text"] as? String
            else { return nil }
        self.init(id: uuid, createdAt: Date(timeIntervalSince1970: createdAtTimeInterval), text: text)
    }
    
    func toDitionary() -> [String: Any] {
        return [
            "uuidString": id.uuidString,
            "createdAt": createdAt.timeIntervalSince1970,
            "text": text
        ]
    }
}
