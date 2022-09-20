//
//  SettingsVCTests.swift
//  PomodoroTests
//
//  Created by Osaretin Uyigue on 9/17/22.
//

import XCTest
@testable import Pomodoro
class SettingsVCTests: XCTestCase {

    
    var sut: SettingsVC!
//    var userDefault: UserDefaults!

    override func setUpWithError() throws {
        sut = SettingsVC()
//        userDefault = UserDefaults.standard
    }

    override func tearDownWithError() throws {
        sut = nil
//        userDefault = nil
    }

    
    
    func testWorkDurationInitialValueIsCorrect() {
        // Arrange
        let userDefault = UserDefaults.standard
        
        
        let workDuration = userDefault.object(forKey: AppConstant.workDuration) as? Int ?? AppConstant.workDurationDefaultValue
        
        
        // Assert
        XCTAssertEqual(sut.workDuration, workDuration)
    }
   
    

    func testShortBreakDurationInitialValueIsCorrect() {

        let userDefault = UserDefaults.standard


        let shortBreakDuration = userDefault.object(forKey: AppConstant.shortBreakDuration) as? Int ?? AppConstant.shorBreakDurationDefaultValue

        XCTAssertEqual(sut.shortBreakDuration, shortBreakDuration)

    }
    
    
    func testLongBreakDurationInitialValueIsCorrect() {

        let userDefault = UserDefaults.standard


        let longBreakDuration = userDefault.object(forKey: AppConstant.longBreakDuration) as? Int ?? AppConstant.longBreakDurationDefaultValue

        XCTAssertEqual(sut.longBreakDuration, longBreakDuration)

    }

}
