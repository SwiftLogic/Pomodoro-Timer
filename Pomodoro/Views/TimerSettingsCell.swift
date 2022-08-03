//
//  TimerSettingsCell.swift
//  Pomodoro
//
//  Created by Osaretin Uyigue on 8/2/22.
//

import UIKit

class TimerSettingsCell: UITableViewCell {
    
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
    static let cellReuseIdentifier = String(describing: TimerSettingsCell.self)
    
    fileprivate(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        return label
    }()
    
    
    fileprivate let totalTimerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
  
    
    fileprivate let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 242, green: 242, blue: 246)
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    
    fileprivate lazy var reduceButton = createButton(imageSystemName: "minus")
    fileprivate lazy var increaseButton = createButton(imageSystemName: "plus")

    
    //MARK: - Methods
    fileprivate func setUpViews() {
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
        
        contentView.addSubview(containerView)
        containerView.fillSuperview(padding: .init(top: 30, left: 20, bottom: 30, right: 20))
        
        
      
        containerView.addSubview(totalTimerLabel)
        totalTimerLabel.centerInSuperview()
        
      
        containerView.addSubview(reduceButton)
        reduceButton.centerYInSuperview()
        reduceButton.trailingAnchor.constraint(equalTo: totalTimerLabel.leadingAnchor, constant: -30).isActive = true

        
        containerView.addSubview(increaseButton)
        increaseButton.centerYInSuperview()
        increaseButton.leadingAnchor.constraint(equalTo: totalTimerLabel.trailingAnchor, constant: 30).isActive = true

        
        
        let attributedText = setupAttributedTextWithFonts(titleString: "50\n", subTitleString: "minutes", attributedTextColor: .gray, mainColor: .appMainColor, mainfont: UIFont.systemFont(ofSize: 40, weight: .heavy), subFont: .systemFont(ofSize: 14))
        
        totalTimerLabel.attributedText = attributedText
        
        
    }
    
    
    
    func configureTitle(with title: String) {
        titleLabel.text = title
    }
    
    
    
    fileprivate func createButton(imageSystemName: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let config = UIImage.SymbolConfiguration(pointSize: 10, weight: .black, scale: .medium)
        let image = UIImage(systemName: imageSystemName, withConfiguration:
                                config)?.withRenderingMode(.alwaysTemplate)

        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .appMainColor
        let buttonDimen: CGFloat = 25
        button.layer.cornerRadius = buttonDimen / 2
        button.constrainHeight(constant: buttonDimen)
        button.constrainWidth(constant: buttonDimen)
        return button
    }
    
    
}
