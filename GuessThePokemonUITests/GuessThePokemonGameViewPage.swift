//
//  GuessThePokemonGameViewPage.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 26/12/2024.
//

import XCTest

final class GuessThePokemonGameViewPage: GuessThePokemonUITests {
    
    
    var app: XCUIApplication {
        GuessThePokemonUITests.app
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    func testGamePlayView() throws {
        XCTAssertTrue(app.staticTexts["Who's That Pokemon?"].exists)
        XCTAssertTrue(app.staticTexts["Score: 0 / 10"].exists)
        // Loop through game rounds
        for _ in 1...10 {
            // Tap the first button (always selects the first option)
            let buttons = app.buttons.allElementsBoundByIndex
            buttons.first?.tap()
            
            // Tap "Next Pokemon"
            let nextButton = app.buttons["Next Pokemon"]
            if nextButton.waitForExistence(timeout: 5.0) {
                nextButton.tap()
            }
        }
        
        // Game Over and Start New Game
        XCTAssertTrue(app.staticTexts["Game Over"].exists)
        app.buttons["Start New Game"].tap()
        //score should be 0 when a new game start
        XCTAssertTrue(app.staticTexts["Score: 0 / 10"].exists)
    }
}
