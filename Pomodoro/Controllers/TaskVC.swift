//
//  TaskVC.swift
//  Pomodoro
//
//  Created by Osaretin Uyigue on 7/26/22.
//

import UIKit
fileprivate let cellReUseIdentifier = "TaskVC-cellReUseIdentifier"

fileprivate enum TaskSection: Int, CustomStringConvertible {
    case  pendingTasks, completedTasks
    var description: String {
        switch self {
        case .pendingTasks: return "Pending Tasks"
        case .completedTasks: return "Completed Tasks"
        }
    }
}

class TaskVC: UIViewController {
    
    //MARK: - View's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        setUpViews()
    }
    
    //MARK: - Properties
    
    fileprivate let taskSections: [TaskSection] = [.pendingTasks, .completedTasks]
    fileprivate var enableSwipeAction = false
    fileprivate var pinnedItemIndexPath: IndexPath?
    
    fileprivate var pendingTasks = [
        TaskItem(description: "Build Pomodoro app's task screen's tableView"),
        TaskItem(description: "Add swipe actions to cells"),
        TaskItem(description: "Add dummy data to task screen"),
        TaskItem(description: "Configure cell's UI"),
        TaskItem(description: "Build and Design Add New Task View"),
        TaskItem(description: "Add gif to Drag to Reorder Collectionview cells Tutorial"),
        TaskItem(description: "Write and Deploy building Youtube Video Player tutorial to blog site"),
        TaskItem(description: "Email Suggestion article")
    ]
    
    
    fileprivate var completedTasks = [
        TaskItem(description: "Add haptic feedback", isCompleted: true),
        TaskItem(description: "Setup navbar", isCompleted: true),
        TaskItem(description: "Configure section header's font", isCompleted: true),
        TaskItem(description: "Add pin task", isCompleted: true),
    ]
    
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsMultipleSelection = false
        return tableView
    }()
    
    
    
    fileprivate lazy var addNewTaskButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20,
                                                 weight: .black,
                                                 scale: .medium)
        
        let image = UIImage(systemName: "plus.circle.fill",
                            withConfiguration:
                                config)?.withRenderingMode(.alwaysTemplate)
        
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.setTitle("ADD NEW", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets = .init(top: 0, left: -15, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(handlePresentTaskView), for: .primaryActionTriggered)
        return button
    }()
    
    
    
    fileprivate lazy var dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDimView))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var addNewTaskView: AddNewTaskView = {
        let addNewtaskView = AddNewTaskView()
        addNewtaskView.delegate = self
        return addNewtaskView
    }()
    
    
    //MARK: - Methods
    fileprivate func configureNavBar() {
        navigationItem.title = "Tasks"
        navigationController?.navigationBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.appMainColor, .font: UIFont.systemFont(ofSize: 20, weight: .medium)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.appMainColor]
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
    
    
    
    
    fileprivate func setUpViews() {
        setUpTableView()
        
        view.addSubview(addNewTaskButton)
        NSLayoutConstraint.activate([
            addNewTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            addNewTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            addNewTaskButton.widthAnchor.constraint(equalToConstant: 180),
            addNewTaskButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    
    fileprivate func setUpTableView() {
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.cellReuseIdentifier)
    }
    
    
    
    private func generateHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    
    private func changeNavBarLineColor(to color: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.appMainColor, .font: UIFont.systemFont(ofSize: 20, weight: .medium)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.appMainColor]
        appearance.shadowColor = color
        appearance.backgroundColor = .white
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
    
    fileprivate func handlePinTask(at indexPath: IndexPath) {
        let hapticFeedBackGenerator = UIImpactFeedbackGenerator(style: .light)
        
        hapticFeedBackGenerator.impactOccurred()
        
        if let pinnedItemIndexPath = pinnedItemIndexPath {
            pendingTasks[pinnedItemIndexPath.row].selected = false
        }
        pinnedItemIndexPath = indexPath
        pendingTasks[indexPath.row].selected = true
        tableView.reloadData()
    }
    
    
   
    
    //MARK: - Target Selectors
    @objc fileprivate func handlePresentTaskView() {
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {return}

        keyWindow.addSubview(dimView)
        dimView.fillSuperview()
        keyWindow.addSubview(addNewTaskView)
        addNewTaskView.anchor(top: keyWindow.safeAreaLayoutGuide.topAnchor, leading: keyWindow.leadingAnchor, bottom: nil, trailing: keyWindow.trailingAnchor, padding: .init(top: 120, left: 0, bottom: 0, right: 0),  size: .init(width: 0, height: 220))
        
        addNewTaskView.prepareViewForUse()

    }
    
    
    
    @objc fileprivate func didTapDimView() {
        handleDismissAddNewTaskView()
    }
}



//MARK: - AddNewTaskViewDelegate
extension TaskVC: AddNewTaskViewDelegate {
    
    func handleSaveTask(_ taskItem: TaskItem) {
        generateHapticFeedback()
        pendingTasks.insert(taskItem, at: 0)
        tableView.reloadData()
        handleDismissAddNewTaskView()

    }
    
    
    func handleUpdate(taskItem: TaskItem) {
        generateHapticFeedback()
        if let index = pendingTasks.firstIndex(of: taskItem) {
            pendingTasks[index] = taskItem
            tableView.reloadData()
        }
        handleDismissAddNewTaskView()
    }
    
    
    
    func handleDismissAddNewTaskView() {
        dimView.removeFromSuperview()
        addNewTaskView.removeFromSuperview()
    }
    
}


//MARK: - TableView Protocols
extension TaskVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.cellReuseIdentifier, for: indexPath) as! TaskCell
        
        switch taskSections[indexPath.section] {
            
        case .pendingTasks:
            let taskItem = pendingTasks[indexPath.row]
            cell.configure(with: taskItem)
            
        case .completedTasks:
            let taskItem = completedTasks[indexPath.row]
            cell.configure(with: taskItem)
        }
        
        return cell
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch taskSections[indexPath.section] {
            
        case .pendingTasks:

            handlePinTask(at: indexPath)
                        
        case .completedTasks:
            break
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch taskSections[section] {
            
        case .pendingTasks:
            return pendingTasks.count
        case .completedTasks:
            return completedTasks.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch taskSections[section] {
        case .pendingTasks:
            return TaskSection.pendingTasks.description
        case .completedTasks:
            return TaskSection.completedTasks.description
        }
    }
    
    

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        var imageName: String

        switch taskSections[indexPath.section] {
        case .pendingTasks:
            imageName = "checkmark.square.fill"
        case .completedTasks:
            imageName = "arrow.uturn.backward.square.fill"
        }

        let completedAction = createSwipeAction(imageName: imageName, targetAction: handleMarkTaskAsComplete(at: indexPath))

        return UISwipeActionsConfiguration(actions: [completedAction])
    }


    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = createSwipeAction(imageName: "xmark.app.fill", targetAction: handleDeleteCell(indexPath: indexPath))
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration

    }


    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return enableSwipeAction
     }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFont(ofSize: 13.5, weight: .black)
        header.textLabel?.textColor = UIColor.lightGray
    }
    
    
    //MARK: - ScrollView Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // hide and show navline based on scrollview contentOffSet
        enableSwipeAction = false
        if scrollView.contentOffset.y > 1 {
            changeNavBarLineColor(to: .lightGray)
        } else {
            changeNavBarLineColor(to: .clear)
        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            stoppedScrolling()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        stoppedScrolling()
    }

    
    private func stoppedScrolling() {
        enableSwipeAction = true
    }
    
    
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        switch taskSections[indexPath.section] {
        case .pendingTasks:
            return pendingTaskMenu(at: indexPath)
        case .completedTasks:
            return completedTaskMenu(at: indexPath)
        }
    }
    
}




//MARK: - Swipe Actions
extension TaskVC {
    
    
    
    
    
    private func handleMarkTaskAsComplete(at indexPath: IndexPath) {
        generateHapticFeedback()
        
        switch taskSections[indexPath.section] {
         // moves pending task to completed
        case .pendingTasks:
            //remove swiped task from pendingTasks
            var completed_Task = pendingTasks.remove(at: indexPath.row)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.tableView.deleteRows(at: [indexPath], with: .right)
            }
            
            //add the task to completedTasks section
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                completed_Task.isCompleted = true
                completed_Task.selected = false
                self.completedTasks.insert(completed_Task, at: 0)
                self.tableView.reloadData()
                
            }
            
            
        // moves completedTask To pending
        case .completedTasks:
            //remove swiped task from completedTasks
            var pending_Task = completedTasks.remove(at: indexPath.row)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.tableView.deleteRows(at: [indexPath], with: .left)
            }
            
            //add the task to pendingTasks section
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                pending_Task.isCompleted = false
                pending_Task.selected = false
                self.pendingTasks.insert(pending_Task, at: 0)
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    
    
    private func handleDeleteCell(indexPath: IndexPath) {
        let alertVC = UIAlertController(title: "Delete Task", message: "Are you sure you want to delete this task?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _  in
            self?.deleteTask(at: indexPath)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _  in
            self?.tableView.reloadRows(at: [indexPath], with: .right)
        }
        
        alertVC.addAction(deleteAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true)
    }
    
    
    
    
    private func deleteTask(at indexPath: IndexPath) {
        generateHapticFeedback()
        switch taskSections[indexPath.section] {
        case .pendingTasks:
            pendingTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
        case .completedTasks:
            completedTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    
    
    
    private func createSwipeAction(imageName: String, targetAction: Void) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: nil) { (action, view, completionHandler) in
            targetAction
            completionHandler(true)
        }
        action.backgroundColor = .white
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .black, scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration:
                                config)?.colored(in: .appMainColor)
        action.image = image
        return action
    }
    
}



//MARK: - Menu Actions
extension TaskVC {
    private func createMenuAction(title: String,
                          imageName: String,
                          targetSelector: Void) -> UIAction {
        let action = UIAction(title: title,
                                   image: UIImage(systemName: imageName),
                                   identifier: nil,
                                   discoverabilityTitle: nil,
                                   state: .off) { _ in
            
            targetSelector
        }
        
        return action
    }
        
    
    
    
    
    private func pendingTaskMenu(at indexPath: IndexPath) -> UIContextMenuConfiguration {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {[weak self] _ in
            
            guard let self = self else {return nil}
            
//            let markAsCompleteOption = self.createMenuAction(title: "Mark as completed", imageName: "checkmark.square.fill", targetSelector: self.printman())
            
            let markAsCompleteOption = UIAction(title: "Mark as completed",
                                       image: UIImage(systemName: "checkmark.square.fill")) {[weak self] _ in
                
                self?.handleMarkTaskAsComplete(at: indexPath)
            }
            
            
            
//            let pinOption = self.createMenuAction(title: "Make a Pinned", imageName: "pin.fill", targetSelector: ())
            
            
            //TODO: - MUST REFACTOR FROM HERE////////
            var pinOption: UIAction
            if let pinnedIndexPath = self.pinnedItemIndexPath {
                
                if pinnedIndexPath == indexPath {
                    pinOption =  UIAction(title: "Remove Pin",
                                          image: UIImage(systemName: "pin.slash.fill")) {[weak self] _ in
                         
                         print("remove pin")
                         
                     }
                } else {
                    pinOption = UIAction(title: "Make a Pinned",
                                         image: UIImage(systemName: "pin.fill")) {[weak self] _ in
                        
                        self?.handlePinTask(at: indexPath)
                    }
                }
                
            } else {
                
                pinOption = UIAction(title: "Make a Pinned",
                                     image: UIImage(systemName: "pin.fill")) {[weak self] _ in
                    
                    self?.handlePinTask(at: indexPath)
                }

            }
            //TODO: - MUST REFACTOR TO HERE////////

            
            //TODO: - change pinnedItemIndexPath: IndexPath to pinnedItem: TaskItem because index path is not a reliable way to check for pins since when we migrate completed task to pending tasks the indexpaths gets rearranged.
           
            
            
//            let editOption = self.createMenuAction(title: "Edit", imageName: "pencil", targetSelector: ())
            
            let editOption = UIAction(title: "Edit",
                                       image: UIImage(systemName: "pencil")) {[weak self] _ in
                guard let self = self else {return}
                
                self.handleEdit(taskItem: self.pendingTasks[indexPath.row])
                
            }

            

            
            
            let deleteOption = UIAction(title: "Delete",
                                       image: UIImage(systemName: "xmark.app.fill")) {[weak self] _ in
                
                self?.handleDeleteCell(indexPath: indexPath)
            }


            
            return UIMenu(title: "",
                          image: nil,
                          identifier: nil,
                          options: .displayInline,
                          children: [markAsCompleteOption, pinOption, editOption, deleteOption])
        }
        
        return config
    }
    
    
    private func completedTaskMenu(at indexPath: IndexPath) -> UIContextMenuConfiguration  {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {[weak self] _ in
            
            guard let self = self else {return nil}
                        
            
            let moveToPendingOption = UIAction(title: "Move to pending Task",
                                       image: UIImage(systemName: "arrow.uturn.backward.square.fill")) {[weak self] _ in
                
                self?.handleMarkTaskAsComplete(at: indexPath)
            }

                        
            let deleteOption = UIAction(title: "Delete",
                                       image: UIImage(systemName: "xmark.app.fill")) {[weak self] _ in
                
                self?.handleDeleteCell(indexPath: indexPath)
            }

            
            return UIMenu(title: "",
                          image: nil,
                          identifier: nil,
                          options: .displayInline,
                          children: [moveToPendingOption, deleteOption])
        }
        
        return config
    }
    
    
    
    fileprivate func handleEdit(taskItem: TaskItem) {
        handlePresentTaskView()
        addNewTaskView.edit(taskItem: taskItem)
    }
    
    
}



extension UIImage {
    func colored(in color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.set()
            self.withRenderingMode(.alwaysTemplate).draw(in: CGRect(origin: .zero, size: size))
        }
    }
}



#if canImport(SwiftUI) && DEBUG
import SwiftUI

let deviceNames: [String] = [
    "iPhone SE (2nd generation)"
]

@available(iOS 13.0, *)
struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                UINavigationController(rootViewController: TaskVC())
                
            }.previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif
