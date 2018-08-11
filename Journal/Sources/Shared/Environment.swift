//
//  Environment.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 8. 11..
//  Copyright © 2018년 roe. All rights reserved.
//

class Environment {
    let entryRepository: EntryRepository
    init(entryRepository: EntryRepository = InMemoryEntryRepository()) {
        self.entryRepository = entryRepository
    } }
