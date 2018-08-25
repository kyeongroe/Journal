//
//  SettingsViewViewModel.swift
//  Journal
//
//  Created by 김경뢰 on 2018. 8. 25..
//  Copyright © 2018년 roe. All rights reserved.
//

import UIKit

struct SettingTableViewCellViewModel {
    let title: String
    let titleFont: UIFont
    let isChecked: Bool
}
struct SettingSectionViewModel {
    let title: String
    let cellModels: [SettingTableViewCellViewModel]
}

class SettingsTableViewViewModel {
    let environment: Environment
    
    private let now: Date
    
    var sectionModels: [SettingSectionViewModel] {
        return environment.settings.sectionModels(with: now)
    }
    
    init(environment: Environment) {
        self.environment = environment
        self.now = environment.now()
    }
    
    func selectOption(at indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            environment.settings.dateFormat = DateFormatOption.all[indexPath.row]
        case 1:
            environment.settings.fontSize = FontSizeOption.all[indexPath.row]
        default:
            break
        }
    }
}

extension DateFormatter {
    static func formatter(with format: String) -> DateFormatter {
        let df = DateFormatter.init()
        df.dateFormat = format
        return df
    }
}

extension Settings {
    func sectionModels(with now: Date) -> [SettingSectionViewModel] {
        return [
            SettingSectionViewModel(
                title: DateFormatOption.name,
                cellModels: DateFormatOption.all.map { option in
                    SettingTableViewCellViewModel(
                        title: DateFormatter.formatter(with: option.rawValue).string(from: now),
                        titleFont: UIFont.systemFont(ofSize: UIFont.systemFontSize),
                        isChecked: option == dateFormat
                    )
                }
            ),
            SettingSectionViewModel(
                title: FontSizeOption.name,
                cellModels: FontSizeOption.all.map { option in
                    SettingTableViewCellViewModel(
                        title: option.description,
                        titleFont: UIFont.systemFont(ofSize: option.rawValue),
                        isChecked: option == fontSize
                    )
                }
            )
        ]
    }
}
