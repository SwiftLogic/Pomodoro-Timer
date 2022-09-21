//
//  TimerVCTests.swift
//  PomodoroTests
//
//  Created by Osaretin Uyigue on 9/1/22.
//

import XCTest
@testable import Pomodoro

class TimerVCTests: XCTestCase {

    
    var sut: TimerVC!
    override func setUpWithError() throws {
        sut = TimerVC()
        sut.loadViewIfNeeded()

    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
   
    //MARK: - startPauseTimerButton
    func testStartPauseButton_HasAction() throws {
        let startPauseButton = sut.startPauseTimerButton
        
        let startPauseButtonActions = try XCTUnwrap(startPauseButton.actions(forTarget: sut, forControlEvent: .touchUpInside), "startPauseButton has no actions assigned to it")
        
        XCTAssertEqual(startPauseButtonActions.count, 1)
        XCTAssertTrue(startPauseButtonActions.contains("didTapStartPauseButton"), "There is no action with the name didTapStartPauseButton assigned to startPauseButton")
        
    }

    
    func testStartPauseButtonConfig_WhenTimeIs_InActive() {
        let startPauseButton = sut.startPauseTimerButton
        sut.configureUIAppearance(for: .inactive)
        let expectedBackgroundColor = UIColor.appMainColor
        let expectedTextColor = UIColor.white
        let expectedTitle = TimerButtonTitle.start
                
        
        XCTAssertEqual(startPauseButton.backgroundColor, expectedBackgroundColor, "startPauseButton backgroundColor does not match the expectedBackgroundColor")
        
        XCTAssertEqual(startPauseButton.titleLabel?.textColor, expectedTextColor, "startPauseButton textColor does not match the expectedTextColor")
        

        XCTAssertEqual(startPauseButton.titleLabel?.text, expectedTitle, "startPauseButton titleLabelText does not match the expectedTitle")

    }
    
    
    func testProgressViewColors_WhenTimeIs_InActive() {
        //Arrange
        let expectedColor = UIColor.appGrayColor
        let progressView = sut.circularProgressBarView.progressLayer
        
        //Act
        sut.configureUIAppearance(for: .inactive)

        //Assert
        XCTAssertEqual(progressView.strokeColor, expectedColor.cgColor, "progressView strokeColor does not match the expectedTextColor")
        
        XCTAssertEqual(sut.timerLabel.textColor, expectedColor, "timerLabel textColor does not match expectedColor")
    }
    
    
    func testStartPauseButtonConfig_WhenTimerIsActive() {
        let startPauseButton = sut.startPauseTimerButton
        sut.configureUIAppearance(for: .active)
        let expectedBackgroundColor = UIColor.appMilkyColor
        let expectedTextColor = UIColor.gray
        let expectedTitle = TimerButtonTitle.pause
                
        
        XCTAssertEqual(startPauseButton.backgroundColor, expectedBackgroundColor, "startPauseButton backgroundColor does not match the expectedBackgroundColor")
        
        XCTAssertEqual(startPauseButton.titleLabel?.textColor, expectedTextColor, "startPauseButton textColor does not match the expectedTextColor")
        

        XCTAssertEqual(startPauseButton.titleLabel?.text, expectedTitle, "startPauseButton titleLabelText does not match the expectedTitle")
    }
    
    
    func testLabelAndCircularProgressViewColors_WhenTimerIsActive() {
        
        
        //Arrange
        let startPauseButton = sut.startPauseTimerButton
        let expectedColor = UIColor.appMainColor
        let progressView = sut.circularProgressBarView.progressLayer
        
        let expectation = expectation(description: "wait for timer to tick")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        //Act
        startPauseButton.sendActions(for: .touchUpInside)
        wait(for: [expectation], timeout: 0.2)

        //Assert
        XCTAssertEqual(progressView.strokeColor, expectedColor.cgColor, "progressView strokeColor does not match the expectedTextColor")
        
        XCTAssertEqual(sut.timerLabel.textColor, expectedColor, "timerLabel textColor does not match expectedColor")
        
    }
    
    
    
    
    func testStartPauseButtonConfigWhenTimeIs_onHold() {
        let startPauseButton = sut.startPauseTimerButton
        sut.configureUIAppearance(for: .onHold)
        let expectedBackgroundColor = UIColor.appMainColor
        let expectedTextColor = UIColor.white
        let expectedTitle = TimerButtonTitle.resume
        
        XCTAssertEqual(startPauseButton.backgroundColor, expectedBackgroundColor, "startPauseButton backgroundColor does not match the expectedBackgroundColor")
        
        XCTAssertEqual(startPauseButton.titleLabel?.textColor, expectedTextColor, "startPauseButton textColor does not match the expectedTextColor")
        

        XCTAssertEqual(startPauseButton.titleLabel?.text, expectedTitle, "startPauseButton titleLabelText does not match the expectedTitle")
    }
    
    func testLabelAndCircularProgressViewColors_WhenTimerOnHold() {
        //Arrange
        let expectedColor = UIColor.appGrayColor
        let progressView = sut.circularProgressBarView.progressLayer
        
        //Act
        sut.configureUIAppearance(for: .onHold)

        //Assert
        XCTAssertEqual(progressView.strokeColor, expectedColor.cgColor, "progressView strokeColor does not match the expectedTextColor")
        
        XCTAssertEqual(sut.timerLabel.textColor, expectedColor, "timerLabel textColor does not match expectedColor")
    }
    
    
    
    func testStartPauseButtonStartsTimerWhenTapped() {
        let startPauseButton = sut.startPauseTimerButton
        startPauseButton.sendActions(for: .touchUpInside)
        XCTAssertNotNil(sut.timer, "Timer was not initialized")
        XCTAssertEqual(sut.currentTimerStatus, .active)

    }
    
    
    func testStartPauseButtonPausesTimer_WhenCurrentTimerStatusIsActive() {
        // start timer
        let startPauseButton = sut.startPauseTimerButton
        startPauseButton.sendActions(for: .touchUpInside)
        // pause timer
        let expectation = expectation(description: "Wait split second to pause timer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.sut.handleStartPauseButtonActions(basedOn: .active)
            
            // assertions
            XCTAssertNil(self.sut.timer, "Timer was not removed")
            XCTAssertEqual(self.sut.currentTimerStatus, .onHold, "currentTimerStatus was not updated to reflect the new status of onHold")
            expectation.fulfill()

        }
        
        wait(for: [expectation], timeout: 0.2)
       
    }
    
    
    func testButtonResumesTimer_WhenCurrentTimerStatusIsOnhold() {
        self.sut.handleStartPauseButtonActions(basedOn: .onHold)
        // assertions
        XCTAssertNotNil(self.sut.timer, "Timer was not resumed")
        XCTAssertEqual(self.sut.currentTimerStatus, .active, "currentTimerStatus was not updated to reflect the new status of active")
    }

    
    
    func testResetTimerButton_HasAction() throws {
        
        let resetTimerBtn = sut.resetTimerBtn
        
        let resetTimerBtnActions = try XCTUnwrap(resetTimerBtn.actions(forTarget: sut, forControlEvent: .touchUpInside), "resetTimerBtn has no actions assigned to it")
        XCTAssertEqual(resetTimerBtnActions.count, 1)
        XCTAssertTrue(resetTimerBtnActions.contains("didTapResetTimerBtn"), "There is no action with the name didTapResetTimerBtn assigned to resetTimerBtn")
    }
    
    
    func testResetTimerBtn_ResetsTimer_WhenTapped() {
        
        // start timer
        let startPauseButton = sut.startPauseTimerButton
        startPauseButton.sendActions(for: .touchUpInside)
        
        let expectation = expectation(description: "Wait split second to pause timer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            let resetTimerBtn = self.sut.resetTimerBtn
            resetTimerBtn.sendActions(for: .touchUpInside)

            
            expectation.fulfill()

        }
        
        wait(for: [expectation], timeout: 2.0)
        
        // assertions
        XCTAssertNil(sut.timer, "Timer was not removed when reset action happened")
        XCTAssertEqual(sut.currentTimerStatus, .inactive, "currentTimerStatus was not updated to inactive upon timer reset action")
        XCTAssertEqual(sut.elapsedTimeInSeconds, 0, "elapsedTimeInSeconds was not resetted to 0")
        XCTAssertEqual(sut.circularProgressBarView.progressLayer.strokeEnd, 1, "circularProgressBarView's progressLayer  was not resetted to 1.0")
        
        
    }
    
    
    
    func testOnTimerCompletionResetViewStateToInactiveTimer()  {

        // start timer
        let startPauseButton = sut.startPauseTimerButton
        sut.currentTimerDuration = 1
        sut.minutesToSecondsMultiplier = 1
        startPauseButton.sendActions(for: .touchUpInside)

        let expectation = expectation(description: "Wait for timer completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {

            expectation.fulfill()

        }

        wait(for: [expectation], timeout: 3.0)

        XCTAssertNil(sut.timer, "Timer was not deallocated from memory")
        XCTAssertEqual(sut.currentTimerStatus, .inactive, "currentTimerStatus was not updated to inactive upon timer completion")
        XCTAssertEqual(sut.elapsedTimeInSeconds, 0, "elapsedTimeInSeconds was not resetted to 0")
        XCTAssertEqual(sut.circularProgressBarView.progressLayer.strokeEnd, 1, "circularProgressBarView's progressLayer  was not resetted to 1.0")
        
        XCTAssertEqual(sut.currentTimerDuration, sut.shortRestDurationInMinutes, "the sut's focusDurationInMinutes was not set to short break mins after timer completion")
        
        XCTAssertEqual(sut.circularProgressBarView.progressLayer.strokeColor, UIColor.appGrayColor.cgColor, "progressLayer color was not set to right color")
       

    }
    
    
    func testOnTimerCompletionPlayCompletionSound() {
        // assert completion sound
        
        // assert progress stroke color and text colors
        
    }
    
    //MARK: - Change Pomodoro State Tests
    
    func testVerifyChangePomodoroStateBtnHasAction() throws {
        //Arrange
        let changePomodoroStateBtn = sut.changePomodoroStateBtn
        
        let changePomodoroStateBtnActions = try XCTUnwrap(changePomodoroStateBtn.actions(forTarget: sut, forControlEvent: .touchUpInside), "changePomodoroStateBtn has no actions assigned to it")
        
        // Assert
        XCTAssertEqual(changePomodoroStateBtnActions.count, 1)
        XCTAssertTrue(changePomodoroStateBtnActions.contains("didTapChangePomodoroStateBtn"), "There is no action with the name didTapChangePomodoroStateBtn assigned to changePomodoroStateBtn")
    }
    
    
//    testChangePomodoroStateBtn_Title_ForWorkMode
    func testAlertVC_IsPresented() throws {
       // Arrange
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }

        guard let firstWindow = firstScene.windows.first else {
            return
        }

        firstWindow.rootViewController = sut
        

        // Act
        sut.changePomodoroStateBtn.sendActions(for: .touchUpInside)
        
        // Assert
        XCTAssert(sut.presentedViewController is UIAlertController, "An alert controller was not presented")
        
    }
    

    func testAlertVC_HasTitle() throws {
        // Arrange
        let expctedTitle = AppConstant.pomodoAlertVCTTitle
        
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }

        guard let firstWindow = firstScene.windows.first else {
            return
        }

        firstWindow.rootViewController = sut
        
        
        // Act
        sut.changePomodoroStateBtn.sendActions(for: .touchUpInside)
        
        // Assert
        XCTAssertEqual(sut.presentedViewController?.title, expctedTitle)
        
    }
    
    
    func testChangePomodoroStateBtn_IsDisabled_WhenTimerIsActive() {
        // Arrange
        let changePomodoroStateBtn = sut.changePomodoroStateBtn
        let startPauseBtn = sut.startPauseTimerButton

        // Act
        startPauseBtn.sendActions(for: .touchUpInside)
        
        let expectation = expectation(description: "wait for timer init")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.2)

        
        // Assert
        XCTAssertFalse(changePomodoroStateBtn.isEnabled, "The changePomodoroStateBtn should be disabled when timer is active")
        
    }
    
    
    func testChangePomodoroStateBtn_IsEnabled_WhenTimerNotActive() {
        
        // Arrange
        let changePomodoroStateBtn = sut.changePomodoroStateBtn
        
        // Act
        sut.configureUIAppearance(for: .inactive)
        
        // Assert
        XCTAssertTrue(changePomodoroStateBtn.isEnabled, "The changePomodoroStateBtn should be isEnabled when timer is inactive")
        
    }
    
    
    func testChangePomodoroStateBtn_IsEnabled_WhenTimer_isOnHold() {
        // Arrange
        let changePomodoroStateBtn = sut.changePomodoroStateBtn
        let startPauseBtn = sut.startPauseTimerButton

        // Act
        startPauseBtn.sendActions(for: .touchUpInside) //start timer
        
        let expectation = expectation(description: "wait for timer init")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            startPauseBtn.sendActions(for: .touchUpInside) // pause timer

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.2)

        
        // Assert
        XCTAssertTrue(changePomodoroStateBtn.isEnabled, "The changePomodoroStateBtn should be isEnabled when timer is onHold")
        
    }
    
    
    func testChangePomodoroStateBtn_Title_ForShortBreakMode() {
        
    }
    
    
    
    func testChangePomodoroStateBtn_Title_ForLongBreakMode() {
        
    }
    
    
    
    // asserts on timer completion pomodoro state is changed to appropriate break mode

    func testPomodoroStateChangesFromWorkToShortBreakOnTimerCompletion() {
         // Arrange
        let startPauseButton = sut.startPauseTimerButton
        sut.currentTimerDuration = 1
        sut.minutesToSecondsMultiplier = 1
        
        
        // Act
        startPauseButton.sendActions(for: .touchUpInside)
        
        let expectation = expectation(description: "Wait for timer completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {

            expectation.fulfill()

        }

        wait(for: [expectation], timeout: 3.0)
        
        // Assert
        XCTAssertEqual(sut.pomodoroSessionType, .shortBreak, "Pomodoro state was not changed from work to work on shortBreak on timer completion")
        XCTAssertEqual(sut.currentTimerDuration, sut.shortRestDurationInMinutes, "currentTimerDuration was not set to shortRestDurationInMinutes")
        
        XCTAssertEqual(sut.changePomodoroStateBtn.title(for: .normal), PomodoroSessionType.shortBreak.description, "changePomodoroStateBtn title was not updated to .shortBreak")


    }
    
    
    
    func testPomodoroStateChanges_FromShortBreakMode_ToWorkModeOnTimerCompletion() {
        // Act
        sut.pomodoroSessionType = .shortBreak
        sut.onTimerCompletion()
        
        // Assert
        XCTAssertEqual(sut.pomodoroSessionType, .work, "Pomodoro state was not changed from shortbreak to work on short break timer completion")
        XCTAssertEqual(sut.changePomodoroStateBtn.title(for: .normal), PomodoroSessionType.work.description)
        

        XCTAssertEqual(sut.currentTimerDuration, sut.workDurationInMinutes, "currentTimerDuration was not set to focusDurationInMinutes")


    }
    
    
    
    func testStoresFirstCompletedFocusSession() {
        // Arrange
        let firstSessionLabel = sut.firstSessionLabel

        // Act
        sut.pomodoroSessionType = .work
        sut.onTimerCompletion()
        
        XCTAssertEqual(sut.nextFocusBlock, .secondSession, "completedFocusSessions should be 1")
        XCTAssertEqual(firstSessionLabel.backgroundColor, UIColor.appMainColor, "firstSessionLabel backgroundColor should be UIColor.appMainColor")
        XCTAssertEqual(firstSessionLabel.textColor, UIColor.white, "firstSessionLabel textColor should be UIColor.white")
        XCTAssertEqual(sut.currentTimerDuration, sut.shortRestDurationInMinutes)

    }
    
    
    func testStoresSecondCompletedFocusSession() {
        // Arrange
        let secondSessionLabel = sut.secondSessionLabel

        // Act
        sut.pomodoroSessionType = .work
        sut.nextFocusBlock = .secondSession
        sut.onTimerCompletion()
        
        // Assert
        XCTAssertEqual(sut.nextFocusBlock, .thirdSession, "completedFocusSessions should be 2")
        XCTAssertEqual(secondSessionLabel.backgroundColor, UIColor.appMainColor, "secondSessionLabel backgroundColor should be UIColor.appMainColor")
        XCTAssertEqual(secondSessionLabel.textColor, UIColor.white, "secondSessionLabel textColor should be UIColor.white")
        XCTAssertEqual(sut.currentTimerDuration, sut.shortRestDurationInMinutes)

        
    }
    
    
    
    func testStoresThirdCompletedFocusSession() {
        // Arrange
        let thirdSessionLabel = sut.thirdSessionLabel

        // Act
        sut.pomodoroSessionType = .work
        sut.nextFocusBlock = .thirdSession
        sut.onTimerCompletion()
        
        // Assert
        XCTAssertEqual(sut.nextFocusBlock, .fourthSession, "completedFocusSessions should be 3")
        XCTAssertEqual(thirdSessionLabel.backgroundColor, UIColor.appMainColor, "thirdSessionLabel backgroundColor should be UIColor.appMainColor")
        XCTAssertEqual(thirdSessionLabel.textColor, UIColor.white, "thirdSessionLabel textColor should be UIColor.white")
        XCTAssertEqual(sut.currentTimerDuration, sut.shortRestDurationInMinutes)

    }
    
    
    func testStoresFourthCompletedFocusSession() {
        // Arrange
        let fourthSessionLabel = sut.fourthSessionLabel

        // Act
        sut.pomodoroSessionType = .work
        sut.nextFocusBlock = .fourthSession
        sut.onTimerCompletion()
        
        // Assert
        XCTAssertEqual(sut.nextFocusBlock, .firstSession, "completedFocusSessions should be 1")
        XCTAssertEqual(fourthSessionLabel.backgroundColor, UIColor.appMainColor, "fourthSessionLabel backgroundColor should be UIColor.appMainColor")
        XCTAssertEqual(fourthSessionLabel.textColor, UIColor.white, "fourthSessionLabel textColor should be UIColor.white")
        XCTAssertEqual(sut.currentTimerDuration, sut.longBreakDurationInMinutes)

    }
    
    
    
    func testSessionLabelsResetsAfterFourthBreak() {
//        // Arrange
        let firstSessionLabel = sut.firstSessionLabel

        let secondSessionLabel = sut.secondSessionLabel

        let thirdSessionLabel = sut.thirdSessionLabel
//
        let fourthSessionLabel = sut.fourthSessionLabel

        // Act
        sut.pomodoroSessionType = .longBreak
        sut.nextFocusBlock = .fourthSession
        
        sut.startPauseTimerButton.sendActions(for: .touchUpInside)
        
        let expectation = expectation(description: "wait for something")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.2)

        
        // Assert
        
        XCTAssertEqual(fourthSessionLabel.backgroundColor, UIColor.clear, "fourthSessionLabel backgroundColor should be UIColor.appMainColor")
        
        XCTAssertEqual(fourthSessionLabel.textColor, .gray)
        
        
        XCTAssertEqual(firstSessionLabel.backgroundColor, UIColor.clear, "firstSessionLabel backgroundColor should be UIColor.appMainColor")
        
        XCTAssertEqual(firstSessionLabel.textColor, .gray)
        
        
        XCTAssertEqual(secondSessionLabel.backgroundColor, UIColor.clear, "secondSessionLabel backgroundColor should be UIColor.appMainColor")
        
        XCTAssertEqual(secondSessionLabel.textColor, .gray)
        
        
        XCTAssertEqual(thirdSessionLabel.backgroundColor, UIColor.clear, "thirdSessionLabel backgroundColor should be UIColor.appMainColor")
        
        XCTAssertEqual(thirdSessionLabel.textColor, .gray)
        
        
    }
    
    
    
    func testChangePomodoroStateFromWork_ToShortBreak() throws {
        // Arrange
        let changePomodoroStateBtn = sut.changePomodoroStateBtn
        
        let expectedAttributedText = createAttributedText(title: sut.shortRestDurationInMinutes, color: .appGrayColor)
        
        // Act
        sut.changePomodoroState(to: .work)
        
        let expectation = expectation(description: "wait for something")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.sut.changePomodoroState(to: .shortBreak)

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)

        
        let timerLabelAttributedText = try XCTUnwrap(sut.timerLabel.attributedText, "unable to unwrap timerLabel text")

        
        // Assert
        XCTAssertEqual(sut.pomodoroSessionType, .shortBreak, "The current pomodoroSessionType should be shortBreak")
        
        XCTAssertEqual(changePomodoroStateBtn.title(for: .normal), PomodoroSessionType.shortBreak.description, "The changePomodoroStateBtn title should be short Break")
        
        XCTAssertEqual(sut.currentTimerDuration, sut.shortRestDurationInMinutes, "The currentTimerDuration should be shortRestDurationInMinutes")
        // assert that label title is accurate
        XCTAssertEqual(timerLabelAttributedText, expectedAttributedText, "timerLabelAttributedText was not updated")
        
        XCTAssertEqual(sut.currentTimerStatus, .inactive, "currentTimerStatus should be inactive")
        
        XCTAssertEqual(sut.circularProgressBarView.progressLayer.strokeEnd, 1.0)
        
        XCTAssertEqual(sut.elapsedTimeInSeconds, 0)
        
        
        
    }
    
    
    func testChangePomodoroStateFromShortBreak_ToWork() throws {
        // Arrange
        let changePomodoroStateBtn = sut.changePomodoroStateBtn
        
        let expectedAttributedText = createAttributedText(title: sut.workDurationInMinutes, color: .appGrayColor)
        
        // Act
        sut.changePomodoroState(to: .shortBreak)

        let expectation = expectation(description: "wait for something")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.sut.changePomodoroState(to: .work)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)

        
        let timerLabelAttributedText = try XCTUnwrap(sut.timerLabel.attributedText, "unable to unwrap timerLabel text")

        
        // Assert
        XCTAssertEqual(sut.pomodoroSessionType, .work, "The current pomodoroSessionType should be work")
        
        XCTAssertEqual(changePomodoroStateBtn.title(for: .normal), PomodoroSessionType.work.description, "The changePomodoroStateBtn title should be work")
        
        XCTAssertEqual(sut.currentTimerDuration, sut.workDurationInMinutes, "The currentTimerDuration should be focusDurationInMinutes")
        // assert that label title is accurate
        XCTAssertEqual(timerLabelAttributedText, expectedAttributedText, "timerLabelAttributedText was not updated")
        
        XCTAssertEqual(sut.currentTimerStatus, .inactive, "currentTimerStatus should be inactive")
        
        XCTAssertEqual(sut.circularProgressBarView.progressLayer.strokeEnd, 1.0)
        
        XCTAssertEqual(sut.elapsedTimeInSeconds, 0)
        
    }
    
    
    func testChangePomodoroStateFromWork_ToLongBreak() throws {
        // Arrange
        let changePomodoroStateBtn = sut.changePomodoroStateBtn
        
        let expectedAttributedText = createAttributedText(title: sut.longBreakDurationInMinutes, color: .appGrayColor)
        
        // Act
        sut.changePomodoroState(to: .work)
        
        let expectation = expectation(description: "wait for something")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.sut.changePomodoroState(to: .longBreak)

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)


        
        let timerLabelAttributedText = try XCTUnwrap(sut.timerLabel.attributedText, "unable to unwrap timerLabel text")

        
        // Assert
        XCTAssertEqual(sut.pomodoroSessionType, .longBreak, "The current pomodoroSessionType should be longBreak")
        
        XCTAssertEqual(changePomodoroStateBtn.title(for: .normal), PomodoroSessionType.longBreak.description, "The changePomodoroStateBtn title should be longBreak")
        
        XCTAssertEqual(sut.currentTimerDuration, sut.longBreakDurationInMinutes, "The currentTimerDuration should be longBreak")
        // assert that label title is accurate
        XCTAssertEqual(timerLabelAttributedText, expectedAttributedText, "timerLabelAttributedText was not updated")
        
        XCTAssertEqual(sut.currentTimerStatus, .inactive, "currentTimerStatus should be inactive")
        
        XCTAssertEqual(sut.circularProgressBarView.progressLayer.strokeEnd, 1.0)
        
        XCTAssertEqual(sut.elapsedTimeInSeconds, 0)
        
    }
    
    
    
    
//    func testChangePomodoroStateFromWork_ToShortBreak() {
//        // Arrange
//        let changePomodoroStateBtn = sut.changePomodoroStateBtn
//
//        // Act
//        sut.changePomodoroState(to: .shortBreak)
//
//        // Assert
//        XCTAssertEqual(sut.pomodoroSessionType, .shortBreak, "The current pomodoroSessionType should be shortBreak")
//
//        XCTAssertEqual(changePomodoroStateBtn.title(for: .normal), PomodoroSessionType.shortBreak.description, "The changePomodoroStateBtn title should be short Break")
//
//        XCTAssertEqual(sut.currentTimerDuration, sut.shortRestDurationInMinutes, "The currentTimerDuration should be shortRestDurationInMinutes")
//
//    }
    
    
    
    func testPomodoroShortBreakState() {
        
    }
    
//
//    func testUpon4thBreakisLongBreak() {
//        clear label colors
//    }
//
//
//    func testUpon4thShortBreak() {
//        clear label colors
//    }
    
    //MARK: - Up Next
    func testResetButtonClearsSessionAndResetsLabels() {
        
    }
    
    func testPomodoroLongBreakState() {
        
    }
    
    
    
    
    func testWorkDurationMatchesActualWorkDuration() {
        // Arrange
        let userDefault = UserDefaults.standard
        
        
        let workDuration = userDefault.object(forKey: .workDuration) as? Int ?? .workDurationDefaultValue
        
                
        // Assert
        XCTAssertEqual(sut.workDurationInMinutes, workDuration)
    }
    
    
    
    func testShortDurationMatchesActualShortBreakDuration() {
        // Arrange
        let userDefault = UserDefaults.standard
        
        
        let shortBreakDuration = userDefault.object(forKey: .shortBreakDuration) as? Int ?? .shorBreakDurationDefaultValue
        
                
        // Assert
        XCTAssertEqual(sut.shortRestDurationInMinutes, shortBreakDuration)
    }
    
    
    func testLongBreakDurationMatchesActualLongBreakDuration() {
        // Arrange
        let userDefault = UserDefaults.standard
        
        
        let longBreakDuration = userDefault.object(forKey: .longBreakDuration) as? Int ?? .longBreakDurationDefaultValue
        
                
        // Assert
        XCTAssertEqual(sut.longBreakDurationInMinutes, longBreakDuration)
    }
    
    
    //MARK: - Helpers
    fileprivate func createAttributedText(title: Int, color: UIColor) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(title)\n", attributes: [NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 40, weight: .heavy)])
        
        attributedText.append(NSMutableAttributedString(string: "minutes", attributes: [NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]))
        return attributedText
    }
}



