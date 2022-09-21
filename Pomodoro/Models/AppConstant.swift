//
//  AppConstant.swift
//  Pomodoro
//
//  Created by Osaretin Uyigue on 9/4/22.
//

import UIKit

struct AppConstant {
    static let pomodoAlertVCTTitle = "Select Session Type"
    static let pomodoAlertVCMessage = "Choose the type of session you wish to begin."
    static let scaleProgressViewDown = 0.8

}



extension Int {
    static let workDurationDefaultValue = 25
    static let shorBreakDurationDefaultValue = 5
    static let longBreakDurationDefaultValue = 25
}


extension String {
    
    static let shortBreakDuration = "shortBreakDuration"
    static let longBreakDuration = "longBreakDuration"
    static let workDuration = "workDuration"
    
}



func getCurrentWorkDuration() -> Int {
   let userDefault = UserDefaults.standard
   
   let workDuration = userDefault.object(forKey: .workDuration) as? Int ?? .workDurationDefaultValue
   
   return workDuration
}



func getCurrentShortBreakDuration() -> Int {
   let userDefault = UserDefaults.standard


   let shortBreakDuration = userDefault.object(forKey: .shortBreakDuration) as? Int ?? .shorBreakDurationDefaultValue
   
   return shortBreakDuration
}




func getCurrentLongBreakDuration() -> Int {
   let userDefault = UserDefaults.standard


   let longBreakDuration = userDefault.object(forKey: .longBreakDuration) as? Int ?? .longBreakDurationDefaultValue
   
   return longBreakDuration
}
