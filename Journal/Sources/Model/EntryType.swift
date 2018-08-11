//
//  EntryType.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 8. 4..
//  Copyright © 2018년 roe. All rights reserved.
//

import Foundation

protocol EntryType: Identifiable, Equatable {
    var id: Int { get }
    var createdAt: Date { get }
    var text: String { get set }
}
