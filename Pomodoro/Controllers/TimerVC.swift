//
//  TimerVC.swift
//  Pomodoro
//
//  Created by Osaretin Uyigue on 7/15/22.
//

import UIKit
import Combine
class TimerVC: UIViewController {

    
    //MARK: - View's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
        setUpInitalState()
    }
    

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpCircularProgressBarView()
    }
    
    //MARK: - Properties
    fileprivate var anyCancellable : AnyCancellable?

    let currentModeButtonColor = UIColor.appMainColor.withAlphaComponent(0.4)
    
    fileprivate(set) var timer: Timer?
    
    fileprivate(set) var elapsedTimeInSeconds = 0
    
    
    fileprivate var elapsedTimeInMinutes: CGFloat {
        get {
            return CGFloat(elapsedTimeInSeconds / 60)
        }
    }
    
    lazy var currentTimerDuration = workDurationInMinutes
    
    var workDurationInMinutes: Int {
        let workDuration = UserDefaults.standard.object(forKey: .workDuration) as? Int ?? .workDurationDefaultValue

        return workDuration
    }
    
    fileprivate(set) lazy var shortRestDurationInMinutes = getCurrentShortBreakDuration()
    
    
    
    fileprivate(set) var longBreakDurationInMinutes = getCurrentLongBreakDuration()

    var nextFocusBlock: FocusSession = .firstSession
    
    var pomodoroSessionType: PomodoroSessionType = .work {
        didSet {
            updateChangePomodoroStateBtnWidth()
        }
    }
    
    var minutesToSecondsMultiplier = 60
    
    fileprivate(set) var currentTimerStatus: TimerStatus = .inactive {
        didSet {
            configureUIAppearance(for: currentTimerStatus)
        }
    }
    
    
    
    fileprivate var changePomodoroStateBtnWidthAnchor = NSLayoutConstraint()
    fileprivate(set) lazy var changePomodoroStateBtn: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 0.8
        button.layer.borderColor = currentModeButtonColor.cgColor
        button.setTitle(pomodoroSessionType.description, for: .normal)
        button.setTitleColor(.appMainColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.backgroundColor = UIColor.appMainColor.withAlphaComponent(0.1)
        button.tintColor = .appMainColor
        let config = UIImage.SymbolConfiguration(pointSize: 10, weight: .black, scale: .medium)
        let image = UIImage(systemName: "chevron.down", withConfiguration:
                                config)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = .init(top: 0, left: 4, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(didTapChangePomodoroStateBtn), for: .touchUpInside)
        return button
    }()
    
    
    
    
    
    fileprivate let currentTaskLabelHeight: CGFloat = 45
    fileprivate lazy var currentTaskLabel: UILabelWithInsets = {
        let label = UILabelWithInsets()
        label.text = "Update Pomodoro-Timer App's README"
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
        button.addTarget(self, action: #selector(didTapTasksButton), for: .touchUpInside)
        return button
    }()
    
    
    fileprivate lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "gear")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = taskButtonDimen / 2
        button.tintColor = .lightGray
        button.backgroundColor = UIColor.rgb(red: 242, green: 242, blue: 246)
        button.addTarget(self, action: #selector(didTapSettingsButton), for: .touchUpInside)
        return button
    }()
    
    
    fileprivate let circularProgressBarParentViewDimen: CGFloat = 150
    fileprivate lazy var circularProgressBarParentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = circularProgressBarParentViewDimen / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapStartPauseButton))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    fileprivate(set) lazy var circularProgressBarView = CircularProgressBarView(frame: .zero)
    fileprivate var circularViewDuration: TimeInterval = 5

    
    
    fileprivate(set) lazy var startPauseTimerButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapStartPauseButton), for: .touchUpInside)
        return button
    }()
    
    
    // reset button
    fileprivate(set) lazy var resetTimerBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapResetTimerBtn), for: .touchUpInside)
        return button
    }()
    
    
    fileprivate(set) lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    fileprivate(set) lazy var firstSessionLabel = createCircularLabel(text: "1")
    fileprivate(set) lazy var secondSessionLabel = createCircularLabel(text: "2")
    fileprivate(set) lazy var thirdSessionLabel = createCircularLabel(text: "3")
    fileprivate(set) lazy var fourthSessionLabel = createCircularLabel(text: "4")

   
    
    
    //MARK: - Methods
    fileprivate func setUpInitalState() {
        configureUIAppearance(for: .inactive)
    }
    
    
    fileprivate func setUpViews() {
        
        // selectionTypeButton
        view.addSubview(changePomodoroStateBtn)
        changePomodoroStateBtn.centerXInSuperview()
        changePomodoroStateBtnWidthAnchor = changePomodoroStateBtn.widthAnchor.constraint(equalToConstant: 85)
        changePomodoroStateBtnWidthAnchor.isActive = true
//        changePomodoroStateBtn.constrainWidth(constant: 85)
        changePomodoroStateBtn.constrainHeight(constant: 35)
        changePomodoroStateBtn.layer.cornerRadius = 35 / 2
        changePomodoroStateBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
   
        // currentTaskLabel
        view.addSubview(currentTaskLabel)
        NSLayoutConstraint.activate([
            currentTaskLabel.centerXAnchor.constraint(equalTo: changePomodoroStateBtn.centerXAnchor),
            currentTaskLabel.topAnchor.constraint(equalTo: changePomodoroStateBtn.bottomAnchor, constant: 40),
            currentTaskLabel.widthAnchor.constraint(lessThanOrEqualToConstant: view.frame.width),
            currentTaskLabel.heightAnchor.constraint(equalToConstant: currentTaskLabelHeight)
        ])
        
        
        // circularRingView
        view.addSubview(circularProgressBarParentView)
        NSLayoutConstraint.activate([
            circularProgressBarParentView.centerXAnchor.constraint(equalTo: changePomodoroStateBtn.centerXAnchor),
            circularProgressBarParentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            circularProgressBarParentView.widthAnchor.constraint(equalToConstant: circularProgressBarParentViewDimen),
            circularProgressBarParentView.heightAnchor.constraint(equalToConstant: circularProgressBarParentViewDimen)
        ])
        
        
        
        // timerLabel
        circularProgressBarParentView.addSubview(timerLabel)
        timerLabel.centerInSuperview()
        
        // startPauseButton
        view.addSubview(startPauseTimerButton)
        NSLayoutConstraint.activate([
            startPauseTimerButton.centerXAnchor.constraint(equalTo: changePomodoroStateBtn.centerXAnchor),
            startPauseTimerButton.topAnchor.constraint(equalTo: circularProgressBarParentView.bottomAnchor, constant: 40),
            startPauseTimerButton.widthAnchor.constraint(equalToConstant: 75),
            startPauseTimerButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
        // resetButton
        view.addSubview(resetTimerBtn)
        NSLayoutConstraint.activate([
            resetTimerBtn.centerXAnchor.constraint(equalTo: changePomodoroStateBtn.centerXAnchor),
            resetTimerBtn.topAnchor.constraint(equalTo: startPauseTimerButton.bottomAnchor, constant: 15),
            
        ])
        
        
        
        // circles
        let stackView = UIStackView(arrangedSubviews: [firstSessionLabel, secondSessionLabel, thirdSessionLabel, fourthSessionLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: resetTimerBtn.bottomAnchor, constant: 15),
            stackView.centerXAnchor.constraint(equalTo: changePomodoroStateBtn.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: startPauseTimerButton.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: startPauseTimerButton.trailingAnchor, constant: -5),
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
    
    
    fileprivate func setUpFocusTimerMinutesLabel(color: UIColor) {
        let attributedText = NSMutableAttributedString(string: "\(currentTimerDuration)\n", attributes: [NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 40, weight: .heavy)])
        
        attributedText.append(NSMutableAttributedString(string: "minutes", attributes: [NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]))
        timerLabel.attributedText = attributedText
    }
    
    
    func setUpCircularProgressBarView() {
        circularProgressBarView.center = circularProgressBarParentView.center
        view.addSubview(circularProgressBarView)
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
    
    
    func configureUIAppearance(for status: TimerStatus) {
        switch status {
        case .active:
            
            changeButtonAppearance(with: TimerButtonTitle.pause, titleColor: .gray, backgroundColor: .appMilkyColor)
            
            circularProgressBarView.progressLayer.strokeColor = UIColor.appMainColor.cgColor

            setUpFocusTimerMinutesLabel(color: .appMainColor)
            
            changePomodoroStateBtn.isEnabled = false
            
            scaleProgressView(up: true)
            

        case .onHold:

            changeButtonAppearance(with: TimerButtonTitle.resume, titleColor: .white, backgroundColor: .appMainColor)
            
            circularProgressBarView.progressLayer.strokeColor = UIColor.appGrayColor.cgColor

            setUpFocusTimerMinutesLabel(color: .appGrayColor)
            changePomodoroStateBtn.isEnabled = true

            scaleProgressView(up: false)


        case .inactive:

            changeButtonAppearance(with: TimerButtonTitle.start, titleColor: .white, backgroundColor: .appMainColor)
            
            circularProgressBarView.progressLayer.strokeColor = UIColor.appGrayColor.cgColor

            setUpFocusTimerMinutesLabel(color: .appGrayColor)
            changePomodoroStateBtn.isEnabled = true

            scaleProgressView(up: false)

        }
    }
    
    
    
    fileprivate func scaleProgressView(up: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {[weak self] in
            if up {
                self?.circularProgressBarView.transform = .identity
                self?.circularProgressBarParentView.transform = .identity
            } else {
                self?.circularProgressBarParentView.transform = .init(scaleX: AppConstant.scaleProgressViewDown, y: AppConstant.scaleProgressViewDown)
                self?.circularProgressBarView.transform = .init(scaleX: AppConstant.scaleProgressViewDown, y: AppConstant.scaleProgressViewDown)
            }
        }
    }
    
    
   fileprivate func changeButtonAppearance(with title: String, titleColor: UIColor, backgroundColor: UIColor) {
        startPauseTimerButton.setTitle(title, for: .normal)
        startPauseTimerButton.setTitleColor(titleColor, for: .normal)
        startPauseTimerButton.backgroundColor = backgroundColor
    }
    
    
    
    fileprivate func updateChangePomodoroStateBtnWidth() {
        var newWidth: CGFloat
        switch pomodoroSessionType {
        case .work:
            newWidth = 85
        case .shortBreak, .longBreak:
            newWidth = 120
        }
        changePomodoroStateBtnWidthAnchor.constant = newWidth
        UIView.animate(withDuration: 0.2) {[weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    

}





//MARK: - Actions
extension TimerVC {
    
    @objc fileprivate func didTapChangePomodoroStateBtn() {
        let alertVC = UIAlertController(title: AppConstant.pomodoAlertVCTTitle, message: AppConstant.pomodoAlertVCMessage, preferredStyle: .actionSheet)
        
        let workAction = UIAlertAction(title: PomodoroSessionType.work.description, style: .default) {[weak self] _ in
            self?.changePomodoroState(to: .work)
        }
        
        
        let shortBreakAction = UIAlertAction(title: PomodoroSessionType.shortBreak.description, style: .default) {[weak self] _ in
            self?.changePomodoroState(to: .shortBreak)
        }
        
        
        let longBreakAction = UIAlertAction(title: PomodoroSessionType.longBreak.description, style: .default) {[weak self] _ in
            self?.changePomodoroState(to: .longBreak)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in}
        alertVC.addAction(workAction)
        alertVC.addAction(shortBreakAction)
        alertVC.addAction(longBreakAction)
        alertVC.addAction(cancelAction)

        present(alertVC, animated: true)

    }
    
    
    func changePomodoroState(to pomodoroState: PomodoroSessionType) {
        switch pomodoroState {
        case .work:
            
            changePomodoroStateBtn.setTitle(PomodoroSessionType.work.description, for: .normal)
            pomodoroSessionType = .work
            currentTimerDuration = workDurationInMinutes
            setUpFocusTimerMinutesLabel(color: .appGrayColor)
//
            
        case .shortBreak: ()
            
            changePomodoroStateBtn.setTitle(PomodoroSessionType.shortBreak.description, for: .normal)
            pomodoroSessionType = .shortBreak
            currentTimerDuration = shortRestDurationInMinutes
            setUpFocusTimerMinutesLabel(color: .appGrayColor)
           
            
        case .longBreak:()
            
            changePomodoroStateBtn.setTitle(PomodoroSessionType.longBreak.description, for: .normal)
            pomodoroSessionType = .longBreak
            currentTimerDuration = longBreakDurationInMinutes
            setUpFocusTimerMinutesLabel(color: .appGrayColor)
            
        }
        
        
        currentTimerStatus = .inactive
        circularProgressBarView.progressLayer.strokeEnd = 1.0
        elapsedTimeInSeconds = 0
        
    }
    
    
    
    
    @objc fileprivate func didTapTasksButton() {
        let taskVC = TaskVC()
        let navVC = UINavigationController(rootViewController: taskVC)
        present(navVC, animated: true)
    }
    
    
    @objc fileprivate func didTapSettingsButton() {
        let settingsVC = SettingsVC()
        subscribeTo(settingsVC: settingsVC)
        present(settingsVC, animated: true)
    }
      
    
    
    fileprivate func subscribeTo(settingsVC: SettingsVC) {
        anyCancellable = settingsVC.durationChangePublisher.sink(receiveValue: { [weak self] update in
            switch update {
            case .increaseDuration(_), .decreaseDuration(_):
                if self?.currentTimerStatus == .inactive {
                    self?.refreshTimerLabelAppearance()
                }
            }
        })
    }
    
    
    fileprivate func refreshTimerLabelAppearance() {
        switch pomodoroSessionType {
        case .work:
            currentTimerDuration = getCurrentWorkDuration()
            setUpFocusTimerMinutesLabel(color: .appGrayColor)
        case .shortBreak:
            currentTimerDuration = getCurrentShortBreakDuration()
            setUpFocusTimerMinutesLabel(color: .appGrayColor)
        case .longBreak:
            currentTimerDuration = getCurrentLongBreakDuration()
            setUpFocusTimerMinutesLabel(color: .appGrayColor)
        }
    }
                                                                 
                                                                 
    
    @objc fileprivate func didTapStartPauseButton() {
       handleStartPauseButtonActions(basedOn: currentTimerStatus)
    }
    
    
     func handleStartPauseButtonActions(basedOn currentTimerStatus: TimerStatus) {
        switch currentTimerStatus {
        case .active:
            pauseTimer()
        case .onHold, .inactive:
            startTimer()
        }
    }
    
    
    fileprivate func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeTicking), userInfo: nil, repeats: true)
        currentTimerStatus = .active
    }
    
    
    fileprivate func pauseTimer() {
        invalidateTimer()
        currentTimerStatus = .onHold
    }
    
    
    fileprivate func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    
    @objc fileprivate func timeTicking() {
        elapsedTimeInSeconds += 1
        let duration = currentTimerDuration * minutesToSecondsMultiplier
        let progress = CGFloat(elapsedTimeInSeconds) / CGFloat(duration)
        circularProgressBarView.progressLayer.strokeEnd = 1 - progress
        
        if duration == elapsedTimeInSeconds {
           onTimerCompletion()
        }
  
    }
    
    
    
     func onTimerCompletion() {
        didTapResetTimerBtn()
         
        circularProgressBarView.progressLayer.strokeColor = UIColor.appGrayColor.cgColor
         
         switch pomodoroSessionType {
             
         case .work:
            //  work focus session completed
             let session = nextFocusBlock
             pomodoroSessionType = session == .fourthSession ? .longBreak : .shortBreak
             currentTimerDuration = session == .fourthSession ? longBreakDurationInMinutes : shortRestDurationInMinutes
             updateCompletedSession(for: nextFocusBlock)

         case .shortBreak:
             //  shorbreak completed

             pomodoroSessionType = .work
             currentTimerDuration = workDurationInMinutes
             
        case .longBreak:
             
             //  longBreak completed
             pomodoroSessionType = .work
             currentTimerDuration = workDurationInMinutes
             
             let labels = [firstSessionLabel, secondSessionLabel, thirdSessionLabel, fourthSessionLabel]
             
             for label in labels {
                 update(label, backgroundColor: .clear, textColor: .gray)
             }
             
         }

         changePomodoroStateBtn.setTitle(pomodoroSessionType.description, for: .normal)
         setUpFocusTimerMinutesLabel(color: .appGrayColor)

    }
    
    @objc fileprivate func didTapResetTimerBtn() {
        invalidateTimer()
        currentTimerStatus = .inactive
        elapsedTimeInSeconds = 0
        circularProgressBarView.progressLayer.strokeEnd = 1.0
    }

    
    
    
    fileprivate func updateCompletedSession(for nextTimeBlock: FocusSession) {
        
        switch nextTimeBlock {
        case .firstSession:
            
            update(firstSessionLabel, backgroundColor: .appMainColor, textColor: .white)
            nextFocusBlock = .secondSession
            
        case .secondSession:
            
            update(secondSessionLabel, backgroundColor: .appMainColor, textColor: .white)
            nextFocusBlock = .thirdSession

        case .thirdSession:
            
            update(thirdSessionLabel, backgroundColor: .appMainColor, textColor: .white)
            nextFocusBlock = .fourthSession
            
        case .fourthSession:
            
            update(fourthSessionLabel, backgroundColor: .appMainColor, textColor: .white)
            nextFocusBlock = .firstSession
            

       
        }
    }
    
    
    fileprivate func update(_ label: UILabel, backgroundColor: UIColor, textColor: UIColor) {
        label.backgroundColor =  backgroundColor
        label.textColor = textColor
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



