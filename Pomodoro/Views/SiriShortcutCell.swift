//
//  SiriShortcutCell.swift
//  Pomodoro
//
//  Created by Osaretin Uyigue on 8/2/22.
//


import UIKit
class SiriShortcutCell: UITableViewCell {
    
    //NOTE: This cell and taskcell should be the same, because theyre composable
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUpViews()
    }
    
    
    
    //MARK: - Properties
    
    static let cellReuseIdentifier = String(describing: SiriShortcutCell.self)
    
    fileprivate let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 242, green: 242, blue: 246)
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    
    fileprivate(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.font = font
        return label
    }()
    
    
    
    
    fileprivate let rightArrowImageView: UIImageView = {
        let imageView = UIImageView()
        
        let config = UIImage.SymbolConfiguration(pointSize: 8, weight: .black, scale: .medium)
        let image = UIImage(systemName: "chevron.right", withConfiguration:
                                config)?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    
    //MARK: - Methods
    
    fileprivate func setUpViews() {
        contentView.addSubview(containerView)
        containerView.fillSuperview(padding: .init(top: 10, left: 20, bottom: 10, right: 20))
        containerView.addSubview(titleLabel)
        titleLabel.centerYInSuperview()
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15).isActive = true
        
        
        containerView.addSubview(rightArrowImageView)
        rightArrowImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15).isActive = true
        rightArrowImageView.centerYInSuperview()
        
        
        
        let attributedText = setupAttributedTextWithFonts(titleString: "Start a work session\n", subTitleString: "Tap to edit your shortcut", attributedTextColor: .lightGray, mainColor: .black, mainfont: UIFont.systemFont(ofSize: 15, weight: .medium), subFont: .systemFont(ofSize: 13))
        
        titleLabel.attributedText = attributedText
        
      

    }
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
