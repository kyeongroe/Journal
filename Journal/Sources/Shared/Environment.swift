//
//  Environment.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 8. 11..
//  Copyright © 2018년 roe. All rights reserved.
//
import Foundation

class Environment {
    let entryRepository: EntryRepository
    var settings: Settings
    let now: () -> Date
    init(
        entryRepository: EntryRepository = InMemoryEntryRepository(),
        settings: Settings = UserDefaults.standard,
        now: @escaping () -> Date = Date.init
        ){
        self.entryRepository = entryRepository
        self.settings = settings
        self.now = now
    }
}
