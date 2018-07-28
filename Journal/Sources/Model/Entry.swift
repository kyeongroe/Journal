//
//  Entry.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 7. 28..
//  Copyright © 2018년 roe. All rights reserved.
//

import Foundation

class Entry {
    
    var id: String
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
    
    func update() {
        
    }
    
    func destroy() {
        
    }
    
    func viewInFullScreen() {
        
    }
    
    func viewInList() {
        
    }
}
