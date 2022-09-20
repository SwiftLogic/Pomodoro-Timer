//
//  PomodoroSessionType.swift
//  Pomodoro
//
//  Created by Osaretin Uyigue on 9/5/22.
//

import UIKit
enum PomodoroSessionType: CustomStringConvertible, CaseIterable {
    case work, shortBreak, longBreak
    
    var description: String {
        switch self {
        case .work:
            return "Work"
        case .shortBreak:
            return "Short Break"
        case .longBreak:
            return "Long Break"
        }
    }
}
