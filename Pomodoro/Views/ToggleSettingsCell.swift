//
//  ToggleSettingsCell.swift
//  Pomodoro
//
//  Created by Osaretin Uyigue on 8/3/22.
//

import UIKit
class ToggleSettingsCell: UITableViewCell {
    
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
    static let cellReuseIdentifier = String(describing: ToggleSettingsCell.self)

    
    fileprivate(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    
    fileprivate let toggleSettingsSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.onTintColor = .appMainColor
        return toggle
    }()
    
    
    fileprivate let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    
    
    
    //MARK: - Methods

    fileprivate func setUpViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggleSettingsSwitch)
        contentView.addSubview(dividerView)
        
        titleLabel.centerYInSuperview()
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        
        toggleSettingsSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        toggleSettingsSwitch.centerYInSuperview()

        dividerView.anchor(top: nil, leading: titleLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 20), size: .init(width: 0, height: 1))
        
    }

}
