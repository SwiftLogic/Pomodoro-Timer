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
        sut.configureStartPauseTimerButton(using: .inactive)
        let expectedBackgroundColor = UIColor.appMainColor
        let expectedTextColor = UIColor.white
        let expectedTitle = TimerButtonTitle.start
                
        
        XCTAssertEqual(startPauseButton.backgroundColor, expectedBackgroundColor, "startPauseButton backgroundColor does not match the expectedBackgroundColor")
        
        XCTAssertEqual(startPauseButton.titleLabel?.textColor, expectedTextColor, "startPauseButton textColor does not match the expectedTextColor")
        

        XCTAssertEqual(startPauseButton.titleLabel?.text, expectedTitle, "startPauseButton titleLabelText does not match the expectedTitle")

    }
    
    
    
    func testStartPauseButtonConfig_WhenTimerIsActive() {
        let startPauseButton = sut.startPauseTimerButton
        sut.configureStartPauseTimerButton(using: .active)
        let expectedBackgroundColor = UIColor.appMilkyColor
        let expectedTextColor = UIColor.gray
        let expectedTitle = TimerButtonTitle.pause
                
        
        XCTAssertEqual(startPauseButton.backgroundColor, expectedBackgroundColor, "startPauseButton backgroundColor does not match the expectedBackgroundColor")
        
        XCTAssertEqual(startPauseButton.titleLabel?.textColor, expectedTextColor, "startPauseButton textColor does not match the expectedTextColor")
        

        XCTAssertEqual(startPauseButton.titleLabel?.text, expectedTitle, "startPauseButton titleLabelText does not match the expectedTitle")
    }
    
    
    func testStartPauseButtonConfigWhenTimeIs_onHold() {
        let startPauseButton = sut.startPauseTimerButton
        sut.configureStartPauseTimerButton(using: .onHold)
        let expectedBackgroundColor = UIColor.appMainColor
        let expectedTextColor = UIColor.white
        let expectedTitle = TimerButtonTitle.resume
        
        XCTAssertEqual(startPauseButton.backgroundColor, expectedBackgroundColor, "startPauseButton backgroundColor does not match the expectedBackgroundColor")
        
        XCTAssertEqual(startPauseButton.titleLabel?.textColor, expectedTextColor, "startPauseButton textColor does not match the expectedTextColor")
        

        XCTAssertEqual(startPauseButton.titleLabel?.text, expectedTitle, "startPauseButton titleLabelText does not match the expectedTitle")
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
        sut.focusDurationInMinutes = 1
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
        
        XCTAssertEqual(sut.focusDurationInMinutes, sut.shortRestDurationInMinutes, "the sut's focusDurationInMinutes was not set to short break mins after timer completion")
        
        XCTAssertEqual(sut.circularProgressBarView.progressLayer.strokeColor, UIColor.appGrayColor.cgColor, "progressLayer color was not set to right color")
       

    }
    
    
    func testOnTimerCompletionPlayCompletionSound() {
        // assert completion sound
        
        // assert progress stroke color and text colors
        
    }
    
    
    func testOnTimerCompletionResetPomodoroStateToShortBreak() {
        // asserts on timer completion pomodoro state is changed to appropriate break mode
        
        let startPauseButton = sut.startPauseTimerButton
        sut.focusDurationInMinutes = 1
        sut.minutesToSecondsMultiplier = 1
        startPauseButton.sendActions(for: .touchUpInside)

        let expectation = expectation(description: "Wait for timer completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {

            expectation.fulfill()

        }

        wait(for: [expectation], timeout: 3.0)
        
        XCTAssertEqual(sut.pomodoroSessionType, .shortBreak)
    }
    
    
    
    func testPomodoroState() {
        
    }
    
}
