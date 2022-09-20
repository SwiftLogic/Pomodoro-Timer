//
//  SettingsItem.swift
//  Pomodoro
//
//  Created by Osaretin Uyigue on 8/2/22.
//

import UIKit
enum SettingsItem: CustomStringConvertible {
    case siriShortCuts, timerSettings([PomodoroSessionType]), toggleSettings([String]), workSessions, more([String])
    
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


