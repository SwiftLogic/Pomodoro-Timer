//
//  TaskItem.swift
//  Pomodoro
//
//  Created by Osaretin Uyigue on 7/28/22.
//

import UIKit
struct TaskItem: Equatable {
    let description: String
    var selected: Bool = false
    var isCompleted: Bool = false
}
