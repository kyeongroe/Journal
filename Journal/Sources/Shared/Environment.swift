//
//  Environment.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 8. 11..
//  Copyright © 2018년 roe. All rights reserved.
//
import Foundation

typealias EntryFactory = (String) -> EntryType

class Environment {
    let entryRepository: EntryRepository
    let entryFactory: EntryFactory
    var settings: Settings
    let now: () -> Date
    init(
        entryRepository: EntryRepository = InMemoryEntryRepository(),
        entryFactory: @escaping EntryFactory = { Entry(text: $0) },
        settings: Settings = UserDefaults.standard,
        now: @escaping () -> Date = Date.init
        ){
        self.entryRepository = entryRepository
        self.entryFactory = entryFactory
        self.settings = settings
        self.now = now
    }
}
