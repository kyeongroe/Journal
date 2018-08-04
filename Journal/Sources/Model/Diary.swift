//
//  Journal.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 7. 28..
//  Copyright © 2018년 roe. All rights reserved.
//

import Foundation

protocol Diary {
    func showList()
    
    func showDetail(entry: Entry)
    
    func showDetailForModifying()
    
    func destroyEntry()   
    
    func showEmptyDetail()
    
    func saveEntry()
}
