//
//  WorkSessionsRecordCell.swift
//  Pomodoro
//
//  Created by Osaretin Uyigue on 8/3/22.
//

import UIKit
class WorkSessionsRecordCell: UITableViewCell {
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUpViews()
    }
    
    
    
    //MARK: - Properties
    
    static let cellReuseIdentifier = String(describing: WorkSessionsRecordCell.self)
    
    fileprivate let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    fileprivate let todayContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 242, green: 242, blue: 246)
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    
    fileprivate let lifeTimeContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 242, green: 242, blue: 246)
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    
    fileprivate lazy var todayLabel = createLabel()
    
    
    fileprivate lazy var lifetimeLabel = createLabel()
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        
        let stackView = UIStackView(arrangedSubviews: [todayLabel, lifetimeLabel])
        stackView.axis = .horizontal
        stackView.spacing = frame.width * 0.1
        
        contentView.addSubview(stackView)
        contentView.addSubview(dividerView)
        
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        
        dividerView.anchor(top: nil, leading: stackView.leadingAnchor, bottom: bottomAnchor, trailing: stackView.trailingAnchor, size: .init(width: 0, height: 1))

        
        
        let todayLabelAttributedText = setupAttributedTextWithFonts(titleString: "0\n", subTitleString: "TODAY", attributedTextColor: .gray, mainColor: .appMainColor, mainfont: UIFont.systemFont(ofSize: 50, weight: .heavy), subFont: .systemFont(ofSize: 15, weight: .bold))
        
        
        let lifetimeLabelAttributedText = setupAttributedTextWithFonts(titleString: "66\n", subTitleString: "LIFETIME", attributedTextColor: .gray, mainColor: .appMainColor, mainfont: UIFont.systemFont(ofSize: 50, weight: .heavy), subFont: .systemFont(ofSize: 15, weight: .bold))

        
        todayLabel.attributedText = todayLabelAttributedText

        lifetimeLabel.attributedText = lifetimeLabelAttributedText
        
        
    }
    
    
    
    fileprivate func createLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .appMilkyColor
        label.textAlignment = .center
        label.layer.cornerRadius = 16
        label.clipsToBounds = true
        return label
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
