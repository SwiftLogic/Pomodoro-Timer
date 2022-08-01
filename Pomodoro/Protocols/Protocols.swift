//
//  Protocols.swift
//  Pomodoro
//
//  Created by Osaretin Uyigue on 7/29/22.
//

import UIKit


//MARK: - AddNewTaskViewDelegate
protocol AddNewTaskViewDelegate: AnyObject {
    func handleSaveTask( _ taskItem: TaskItem)
    func handleUpdate(taskItem: TaskItem)
    func handleDismissAddNewTaskView()
}
