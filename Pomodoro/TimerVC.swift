//
//  TimerVC.swift
//  Pomodoro
//
//  Created by Osaretin Uyigue on 7/15/22.
//

import UIKit

class TimerVC: UIViewController {

    
    //MARK: - View's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
    }

    
    //MARK: - Properties
    let selectionTypeButtonColor = UIColor.appMainColor.withAlphaComponent(0.4)
    fileprivate lazy var selectionTypeButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor.appMainColor.cgColor
        button.setTitle("Work", for: .normal)
        button.setTitleColor(selectionTypeButtonColor, for: .normal)
        return button
    }()
    
    
    fileprivate let currentTaskLabelHeight: CGFloat = 45
    fileprivate lazy var currentTaskLabel: UILabelWithInsets = {
        let label = UILabelWithInsets()
        label.text = "Current Task Label"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.rgb(red: 242, green: 242, blue: 246)
        label.textInsets = .init(top: 0, left: 15, bottom: 0, right: 15)
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = currentTaskLabelHeight / 2
        return label
    }()
    
    
    let taskButtonDimen: CGFloat = 60
    fileprivate lazy var taskButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "rectangle.grid.1x2.fill")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = taskButtonDimen / 2
        button.tintColor = .lightGray
        button.backgroundColor = UIColor.rgb(red: 242, green: 242, blue: 246)
        return button
    }()
    
    
    fileprivate lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "gear")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = taskButtonDimen / 2
        button.tintColor = .lightGray
        button.backgroundColor = UIColor.rgb(red: 242, green: 242, blue: 246)
        return button
    }()
    
    
    // four circular labels
    fileprivate let circularRingViewDimen: CGFloat = 150
    fileprivate lazy var circularRingView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = circularRingViewDimen / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    fileprivate let startPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("START", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = .appMainColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // reset button
    fileprivate let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // resume / pause timer button
    
    
    // circular progress view
    
    fileprivate lazy var firstSessionLabel = createCircularLabel(text: "1")
    fileprivate lazy var secondSessionLabel = createCircularLabel(text: "2")
    fileprivate lazy var thirdSessionLabel = createCircularLabel(text: "3")
    fileprivate lazy var fourthSessionLabel = createCircularLabel(text: "4")

    
    
    //MARK: - Methods
    fileprivate func setUpViews() {
        
        // selectionTypeButton
        view.addSubview(selectionTypeButton)
        selectionTypeButton.centerXInSuperview()
        selectionTypeButton.constrainWidth(constant: 100)
        selectionTypeButton.constrainHeight(constant: 40)
        selectionTypeButton.layer.cornerRadius = 40 / 2
        selectionTypeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        
        let imageAttachment = NSTextAttachment()
        // If you want to enable Color in the SF Symbols.
        imageAttachment.image = UIImage(systemName: "chevron.down")?.withTintColor(selectionTypeButtonColor)
        let fullString = NSMutableAttributedString(string: "Work ")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        selectionTypeButton.setAttributedTitle(fullString, for: .normal)
        
        // currentTaskLabel
        view.addSubview(currentTaskLabel)
        NSLayoutConstraint.activate([
            currentTaskLabel.centerXAnchor.constraint(equalTo: selectionTypeButton.centerXAnchor),
            currentTaskLabel.topAnchor.constraint(equalTo: selectionTypeButton.bottomAnchor, constant: 40),
            currentTaskLabel.widthAnchor.constraint(lessThanOrEqualToConstant: view.frame.width),
            currentTaskLabel.heightAnchor.constraint(equalToConstant: currentTaskLabelHeight)
        ])
        
        
        // circularRingView
        view.addSubview(circularRingView)
        NSLayoutConstraint.activate([
            circularRingView.centerXAnchor.constraint(equalTo: selectionTypeButton.centerXAnchor),
            circularRingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            circularRingView.widthAnchor.constraint(equalToConstant: circularRingViewDimen),
            circularRingView.heightAnchor.constraint(equalToConstant: circularRingViewDimen)
        ])
        
        
        
        // startPauseButton
        view.addSubview(startPauseButton)
        NSLayoutConstraint.activate([
            startPauseButton.centerXAnchor.constraint(equalTo: selectionTypeButton.centerXAnchor),
            startPauseButton.topAnchor.constraint(equalTo: circularRingView.bottomAnchor, constant: 40),
            startPauseButton.widthAnchor.constraint(equalToConstant: 75),
            startPauseButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
        // resetButton
        view.addSubview(resetButton)
        NSLayoutConstraint.activate([
            resetButton.centerXAnchor.constraint(equalTo: selectionTypeButton.centerXAnchor),
            resetButton.topAnchor.constraint(equalTo: startPauseButton.bottomAnchor, constant: 15),
            
        ])
        
        
        
        // circles
        let stackView = UIStackView(arrangedSubviews: [firstSessionLabel, secondSessionLabel, thirdSessionLabel, fourthSessionLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 15),
            stackView.centerXAnchor.constraint(equalTo: selectionTypeButton.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: startPauseButton.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: startPauseButton.trailingAnchor, constant: -5),
            stackView.heightAnchor.constraint(equalToConstant: 10)
        ])
        
        
        
        // taskButton
        let xAxisPadding: CGFloat = view.frame.width * 0.15
        let yAxisPadding: CGFloat = 30
        view.addSubview(taskButton)
        taskButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: xAxisPadding, bottom: yAxisPadding, right: 0), size: .init(width: taskButtonDimen, height: taskButtonDimen))
        
        
        
        // settingsButton
        view.addSubview(settingsButton)
        settingsButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: yAxisPadding, right: xAxisPadding), size: .init(width: taskButtonDimen, height: taskButtonDimen))
        
        
    }
    
    
    
    
    fileprivate func createCircularLabel(text: String) -> UILabel {
        let label = UILabelWithInsets()
        label.textColor = .gray
        label.text = text
        label.textAlignment = .center
        label.textInsets = .init(top: 3, left: 3, bottom: 3, right: 3)
        label.font = UIFont.systemFont(ofSize: 8)
        label.layer.cornerRadius = 10 / 2
        label.layer.borderColor = UIColor.appMainColor.cgColor
        label.layer.borderWidth = 1
        label.constrainHeight(constant: 10)
        label.constrainWidth(constant: 10)
        return label
    }

}



class UILabelWithInsets : UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
        
    }
}


