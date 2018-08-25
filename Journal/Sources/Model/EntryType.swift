//
//  EntryType.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 8. 4..
//  Copyright © 2018년 roe. All rights reserved.
//

import Foundation

protocol EntryType: Identifiable {
    var id: UUID { get }
    var createdAt: Date { get }
    var text: String { get set }
}

extension EntryType {
    static func ==(lhs: EntryType, rhs: EntryType) -> Bool {
        return lhs.id == rhs.id
            && lhs.createdAt == rhs.createdAt
            && lhs.text == rhs.text
    }
}
