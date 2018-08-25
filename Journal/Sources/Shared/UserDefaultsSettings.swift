//
//  UserDefaultsSettings.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 8. 25..
//  Copyright © 2018년 roe. All rights reserved.
//

import UIKit

private let dateFormatOptionKey: String = "dateFormatOptionKey"
private let fontSizeOptionKey: String = "fontSizeOptionKey"
extension UserDefaults: Settings {
    var dateFormat: DateFormatOption {
        set {
            set(newValue.rawValue, forKey: dateFormatOptionKey)
            synchronize()
        }
        get {
            let rawValue = object(forKey: dateFormatOptionKey) as? String
            return rawValue.flatMap(DateFormatOption.init) ?? DateFormatOption.default
        } }
    var fontSize: FontSizeOption {
        set {
            set(newValue.rawValue, forKey: fontSizeOptionKey)
            synchronize()
        }
        get {
            let rawValue = object(forKey: fontSizeOptionKey) as? CGFloat
            return rawValue.flatMap(FontSizeOption.init) ?? FontSizeOption.default
        } }
}
