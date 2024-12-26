//
//  GuessThePokemonUITests.swift
//  GuessThePokemonUITests
//
//  Created by Amol Jagtap on 22/12/2024.
//

import XCTest

class GuessThePokemonUITests: XCTestCase {

    static let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        GuessThePokemonUITests.app.launchArguments = ["ui-testing"]
        GuessThePokemonUITests.app.launch()
        XCUIDevice.shared.orientation = .portrait
    }
}
