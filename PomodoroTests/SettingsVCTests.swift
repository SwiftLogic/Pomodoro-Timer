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

    override func setUpWithError() throws {
        sut = SettingsVC()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    
    
    func testWorkDurationInitialValueIsCorrect() {
        // Arrange
        let userDefault = UserDefaults.standard
        
        
        let workDuration = userDefault.object(forKey: .workDuration) as? Int ?? .workDurationDefaultValue
        
        
        // Assert
        XCTAssertEqual(sut.workDuration, workDuration)
    }
   
    

    func testShortBreakDurationInitialValueIsCorrect() {

        let userDefault = UserDefaults.standard


        let shortBreakDuration = userDefault.object(forKey: .shortBreakDuration) as? Int ?? .shorBreakDurationDefaultValue

        XCTAssertEqual(sut.shortBreakDuration, shortBreakDuration)

    }
    
    
    func testLongBreakDurationInitialValueIsCorrect() {

        let userDefault = UserDefaults.standard


        let longBreakDuration = userDefault.object(forKey: .longBreakDuration) as? Int ?? .longBreakDurationDefaultValue

        XCTAssertEqual(sut.longBreakDuration, longBreakDuration)

    }

    
    
    func testIncreaseWorkDuration() {
        
        // Arrange
        let userDefault = UserDefaults.standard
        
        
        let workDuration = userDefault.object(forKey: .workDuration) as? Int ?? .workDurationDefaultValue
        
        
        // Act
        sut.increase(session: .work, by: 1)
        
        
        // Assert
        XCTAssertEqual(sut.workDuration, workDuration + 1)
        XCTAssertEqual(getCurrentWorkDuration(), sut.workDuration)
    }
    
    
    func testDecreaseWorkDuration() {
        // Arrange
        let userDefault = UserDefaults.standard
        
        
        let workDuration = userDefault.object(forKey: .workDuration) as? Int ?? .workDurationDefaultValue
        
        
        // Act
        sut.decrease(session: .work, by: 1)
        
        // Assert
        XCTAssertEqual(sut.workDuration, workDuration - 1)
        XCTAssertEqual(getCurrentWorkDuration(), sut.workDuration)

    }
    
    
    func testTryDecreasingWorkDurationBelowZero() {
        // Arrange
        
        // Act
        sut.workDuration = 0
        sut.decrease(session: .work, by: 1)
        
        // Assert
        XCTAssertEqual(sut.workDuration, 0)
    }
    
    
    func testIncreaseShortBreakDuration() {
        // Arrange
        let userDefault = UserDefaults.standard
        
        let shortBreakDuration = userDefault.object(forKey: .shortBreakDuration) as? Int ?? .shorBreakDurationDefaultValue
        
        // Act
        sut.increase(session: .shortBreak, by: 1)
        
        // Assert
        XCTAssertEqual(sut.shortBreakDuration, shortBreakDuration + 1)
        XCTAssertEqual(getCurrentShortBreakDuration(), sut.shortBreakDuration)

    }
   
    
    func testDecreaseShortBreakDuration() {
        // Arrange
        let userDefault = UserDefaults.standard
        
        let shortBreakDuration = userDefault.object(forKey: .shortBreakDuration) as? Int ?? .shorBreakDurationDefaultValue
        
        // Act
        sut.decrease(session: .shortBreak, by: 1)
        
        // Assert
        XCTAssertEqual(sut.shortBreakDuration, shortBreakDuration - 1)
        XCTAssertEqual(getCurrentShortBreakDuration(), sut.shortBreakDuration)

    }
    
    
    func testTryDecreasingShortBreakBelowZero() {
        
        // Act
        sut.shortBreakDuration = 0
        sut.decrease(session: .shortBreak, by: 1)
        
        // Assert
        XCTAssertEqual(sut.shortBreakDuration, 0)
    }
    
    
    
    
    func testIncreaseLongBreakDuration() {
        // Arrange
        let userDefault = UserDefaults.standard
        
        let longBreakDuration = userDefault.object(forKey: .longBreakDuration) as? Int ?? .longBreakDurationDefaultValue
        
        // Act
        sut.increase(session: .longBreak, by: 1)

        // Assert
        XCTAssertEqual(sut.longBreakDuration, longBreakDuration + 1)
        XCTAssertEqual(getCurrentLongBreakDuration(), sut.longBreakDuration)

    }
    
    
    func testDecreaseLongBreakDuration() {
        // Arrange
        let userDefault = UserDefaults.standard
        
        let longBreakDuration = userDefault.object(forKey: .longBreakDuration) as? Int ?? .longBreakDurationDefaultValue
        
        // Act
        sut.decrease(session: .longBreak, by: 1)
        
        // Assert
        XCTAssertEqual(sut.longBreakDuration, longBreakDuration - 1)
        XCTAssertEqual(getCurrentLongBreakDuration(), sut.longBreakDuration)

        
    }
    
    
    func testTryDecreasingLongBreakDurationBelowZero() {
        // Act
        sut.longBreakDuration = 0
        sut.decrease(session: .longBreak, by: 1)
        // Assert
        XCTAssertEqual(sut.longBreakDuration, 0)
    }
}


