//
//  Entry.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 7. 28..
//  Copyright © 2018년 roe. All rights reserved.
//

import Foundation

class Entry {
    
    let id: String
    var title: String
    var contents: String
    var creator: String = "Cool Roe"
    
    let created_dt: Date
    var updated_dt: Date
    var deleted_dt: Date?
    
    init(title: String, contents: String) {
        self.id = "using uniqueid generator"
        self.title = title
        self.contents = contents
        
        self.created_dt = Date()
        self.updated_dt = Date()
    }
    
    func update(contents: String) {
        self.contents = contents
        
        self.updated_dt = Date()
        //sync or store
    }
    
    func destroy() {
        //sync or delete
    }
    
    func viewInFullScreen() {
        
    }
    
    func viewInList() {
        
    }
}
