//
//  Foundation+Journal.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 8. 18..
//  Copyright © 2018년 roe. All rights reserved.
//

import Foundation

extension DateFormatter {
    static var entryDateFormatter: DateFormatter = {
        let df = DateFormatter.init()
        df.dateFormat = "yyyy. M. dd. EEE"
        return df
    }()
    
    static var timeFormatter: DateFormatter = {
        let df = DateFormatter.init()
        df.dateStyle = .none
        df.timeStyle = .short
        return df
    }()
    
    static var ampmFormatter: DateFormatter = {
        let df = DateFormatter.init()
        df.dateFormat = "a"
        return df
    }()
}

extension Date {
    var hmsRemoved: Date? {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)
    }
    
    static func before(_ days: Int) -> Date {
        let timeInterval = Double(days) * 24 * 60 * 60
        return Date(timeIntervalSinceNow: -timeInterval)
    }
}

extension Array where Element: Hashable {
    func unique() -> [Element] {
        var set: Set<Element> = []
        var result: [Element] = []
        for element in self where set.contains(element) == false {
            set.insert(element)
            result.append(element)
        }
        return result
    }
}
