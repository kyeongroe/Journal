//
//  Setting.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 8. 25..
//  Copyright © 2018년 roe. All rights reserved.
//

import UIKit

protocol SettingOption {
    static var name: String { get }
    static var `default`: Self { get }
    static var all: [Self] { get }
}

enum DateFormatOption: String, SettingOption {
    case yearFirst = "yyyy. M. dd. EEE"
    case dayOfWeekFirst = "EEE, MMM d, yyyy"
    static var name: String { return "날짜 표시" }
    static var `default`: DateFormatOption { return .yearFirst }
    static var all: [DateFormatOption] { return [.yearFirst, .dayOfWeekFirst] }
}

enum FontSizeOption: CGFloat, SettingOption, CustomStringConvertible {
    case small = 14
    case medium = 16
    case large = 18
    case xlarge = 24
    var description: String {
        switch self {
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large"
        case .xlarge: return "XLarge"
        }
    }
    static var name: String { return "글자 크기" }
    static var `default`: FontSizeOption { return .medium }
    static var all: [FontSizeOption] { return [.small, .medium, .large, .xlarge] }
}

protocol Settings {
    var dateFormat: DateFormatOption { get set }
    var fontSize: FontSizeOption { get set }
}

class InMemorySettings: Settings {
    var dateFormat: DateFormatOption = DateFormatOption.default
    var fontSize: FontSizeOption = FontSizeOption.default
}

