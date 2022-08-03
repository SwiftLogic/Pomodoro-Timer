//
//  MoreSettingsCell.swift
//  Pomodoro
//
//  Created by Osaretin Uyigue on 8/2/22.
//

import UIKit
class MoreSettingsCell: SiriShortcutCell {
    
    static let cellIdentifier = String(describing: MoreSettingsCell.self)
    
    func configureTitle(with title: String) {
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    }
}
