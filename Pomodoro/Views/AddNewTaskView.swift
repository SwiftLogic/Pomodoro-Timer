//
//  AddNewTaskView.swift
//  Pomodoro
//
//  Created by Osaretin Uyigue on 7/29/22.
//

import UIKit
class AddNewTaskView: UIView {
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .appMilkyColor
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Properties
    fileprivate var isEditingTaskItem = false
    fileprivate var editedTaskItem: TaskItem?
    
    weak var delegate: AddNewTaskViewDelegate?
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add new task"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    fileprivate lazy var cancelButton = createNavButton(with: "Cancel", titleColor: .red, font: UIFont.systemFont(ofSize: 16, weight: .light), selector: #selector(didTapCancelButton))
    
    
    fileprivate lazy var saveButton = createNavButton(with: "Save", titleColor: .appMainColor, font: UIFont.systemFont(ofSize: 16.5, weight: .black), selector: #selector(didTapSaveButton))
    
    
    fileprivate lazy var addTaskTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "e.g. Design Pomodoro App"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.cornerRadius = 10
        tf.clipsToBounds = true
        tf.backgroundColor = .white
        tf.returnKeyType = .done
        tf.delegate = self
        return tf
    }()

    
    //MARK: - Methods
    fileprivate func setUpViews() {
        layer.cornerRadius = 16
        addSubview(cancelButton)
        addSubview(saveButton)
        addSubview(titleLabel)
        addSubview(addTaskTextField)
        
        
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            saveButton.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            
            titleLabel.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: 0),
            
            
            addTaskTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            addTaskTextField.leadingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: 0),
            addTaskTextField.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor, constant: 0),
            addTaskTextField.heightAnchor.constraint(equalToConstant: 55),

        ])
        
        
        addHorizontalPaddingToTextField(tf: addTaskTextField)
        
        
        
    }
    
    
    fileprivate func createNavButton(with title: String, titleColor: UIColor, font: UIFont, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = font
        button.addTarget(self, action: selector, for: .primaryActionTriggered)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    
    private func addHorizontalPaddingToTextField(tf: UITextField) {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tf.frame.size.height))
        leftView.backgroundColor = tf.backgroundColor
        tf.leftView = leftView
        tf.leftViewMode = UITextField.ViewMode.always
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tf.frame.size.height))
        rightView.backgroundColor = tf.backgroundColor
        tf.rightView = rightView
        tf.rightViewMode = UITextField.ViewMode.always
    }
    
    
    
    func prepareViewForUse() {
        editedTaskItem = nil
        isEditingTaskItem = false
        addTaskTextField.text = ""
        addTaskTextField.becomeFirstResponder()
        
    }
    
    
    func edit(taskItem: TaskItem) {
        editedTaskItem = taskItem
        isEditingTaskItem = true
        addTaskTextField.text = taskItem.description
    }
    
    
    //MARK: - Target Selectors
    @objc fileprivate func didTapCancelButton() {
        delegate?.handleDismissAddNewTaskView()
    }
    
    
    @objc fileprivate func didTapSaveButton() {
        guard let text = addTaskTextField.text, text.count > 1  else {
            delegate?.handleDismissAddNewTaskView()
            return}
        
        if isEditingTaskItem {
            guard let editedTaskItem = editedTaskItem else {return}
            let updatedItem = TaskItem(id: editedTaskItem.id, description: text, selected: editedTaskItem.selected, isCompleted: false)
            delegate?.handleUpdate(taskItem: updatedItem)
            
        } else {
            let taskItem = TaskItem(description: text, selected: false, isCompleted: false)
            delegate?.handleSaveTask(taskItem)
        }
    }
    
}

//MARK: - UITextFieldDelegate
extension AddNewTaskView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        didTapSaveButton()
        return true
    }
}
