//
//  SettingsItem.swift
//  Pomodoro
//
//  Created by Osaretin Uyigue on 8/2/22.
//

import UIKit
enum SettingsItem: Int, CustomStringConvertible {
    case siriShortCuts, timerSettings, toggleSettings, workSessions, more
    
    var description: String {
        switch self {
        case .siriShortCuts:
            return "Siri Shortcuts"
        case .timerSettings, .toggleSettings:
            return "Settings"
        case .workSessions:
            return "Work Sessions"
        case .more:
            return "More"
        }
    }
}


