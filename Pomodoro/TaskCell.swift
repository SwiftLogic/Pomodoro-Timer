//
//  TaskCell.swift
//  Pomodoro
//
//  Created by Osaretin Uyigue on 7/26/22.
//

import UIKit
class TaskCell: UITableViewCell {
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    //MARK: - Properties
    static let cellReuseIdentifier = String(describing: TaskCell.self)
    
    fileprivate let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 242, green: 242, blue: 246)
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    
    fileprivate(set) var taskTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Added Dummy Data"
        label.numberOfLines = 2
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.font = font
        return label
    }()
    
    
    //MARK: - Methods
    fileprivate func setUpViews() {
        contentView.addSubview(containerView)
        containerView.fillSuperview(padding: .init(top: 10, left: 20, bottom: 10, right: 20))
        containerView.addSubview(taskTitleLabel)
        taskTitleLabel.centerYInSuperview()
        taskTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15).isActive = true
        taskTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15).isActive = true

    }
    
    
    
}
