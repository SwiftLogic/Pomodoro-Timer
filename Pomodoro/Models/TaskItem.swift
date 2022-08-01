//
//  TaskItem.swift
//  Pomodoro
//
//  Created by Osaretin Uyigue on 7/28/22.
//

import UIKit
struct TaskItem: Equatable {
    var id = UUID().uuidString
    let description: String
    var selected: Bool = false
    var isCompleted: Bool = false
    

    static func == (lhs: TaskItem, rhs: TaskItem) -> Bool {
        return lhs.id == rhs.id
    }
}
