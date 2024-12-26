//
//  PokemonGameViewModelTests.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 26/12/2024.
//

import XCTest
import Combine
@testable import GuessThePokemon

final class PokemonGameViewModelTests: XCTestCase {

    private var viewModel: PokemonGameViewModel!
    private var mockPokemonService: MockPokemonService!
    private var mockImageService: MockPokemonCharacterImageService!
    private var cancellables: Set<AnyCancellable>!
    
    var pagination = Pagination(limit: 4, offset: 0, maxCount: 4)

    override func setUp() {
        super.setUp()
        mockPokemonService = MockPokemonService()
        mockImageService = MockPokemonCharacterImageService()
        viewModel = PokemonGameViewModel(pokemonService: mockPokemonService, pokemonCharacterImageService: mockImageService)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockPokemonService = nil
        mockImageService = nil
        cancellables = nil
        super.tearDown()
    }

    func testLoadGame_initialState_loading() {
        let expectation = XCTestExpectation(description: "View state is set to loading")
        viewModel.$viewState
            .dropFirst()
            .sink { state in
                if state == .loading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.loadGame()
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadGame_fetchSuccess_gameStarted() {
        let expectation = XCTestExpectation(description: "Start a game after successful data fetch")
        viewModel.$viewState
            .dropFirst()
            .sink { state in
                if state == .gameStarted {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.loadGame()
        wait(for: [expectation], timeout: 1.0)
    }

    func testUpdateGameScore_correctAnswer_incrementsScore() {
        viewModel.score = 0
        viewModel.updateGameScore(isCorrectAnswer: true)
        XCTAssertEqual(viewModel.score, 1)
        XCTAssertTrue(viewModel.showAnswer)
    }

    func testUpdateGameScore_incorrectAnswer_doesNotIncrementScore() {
        viewModel.score = 0
        viewModel.updateGameScore(isCorrectAnswer: false)
        XCTAssertEqual(viewModel.score, 0)
        XCTAssertTrue(viewModel.showAnswer)
    }

    func testRevealAnswer_correctOption_updatesScoreAndRemainingCharacters() {
        viewModel.options = [
            PokemonGameOption(name: "Bulbasaur", isCorrect: false),
            PokemonGameOption(name: "Pikachu", isCorrect: true),
            PokemonGameOption(name: "Squirtle", isCorrect: false),
            PokemonGameOption(name: "Blastoise", isCorrect: false)
        ]
        viewModel.remainingCharacters = 3
        viewModel.score = 0
        viewModel.revealAnswer(selectedIndex: 1)
        XCTAssertEqual(viewModel.score, 1)
        XCTAssertEqual(viewModel.remainingCharacters, 2)
    }

    func testRevealAnswer_incorrectOption_updatesRemainingCharacters() {
        viewModel.options = [
            PokemonGameOption(name: "Bulbasaur", isCorrect: false),
            PokemonGameOption(name: "Pikachu", isCorrect: true),
            PokemonGameOption(name: "Squirtle", isCorrect: false),
            PokemonGameOption(name: "Blastoise", isCorrect: false)
        ]
        viewModel.remainingCharacters = 3
        viewModel.score = 0
        viewModel.revealAnswer(selectedIndex: 0)
        XCTAssertEqual(viewModel.score, 0)
        XCTAssertEqual(viewModel.remainingCharacters, 2)
    }

    func testStartNewGame_resetsState() {
        viewModel.score = 5
        viewModel.remainingCharacters = 2
        viewModel.showAnswer = true
        viewModel.startNewGame()
        XCTAssertEqual(viewModel.score, 0)
        XCTAssertEqual(viewModel.remainingCharacters, viewModel.totalCharactersPerGame)
        XCTAssertFalse(viewModel.showAnswer)
    }

    func testSelectRandomPokemonCharacter_updatesCurrentCharacterAndOptions() {
        viewModel.loadGame()
        viewModel.selectRandomPokemonCharacter()
        XCTAssertNotNil(viewModel.currentCharacter)
        XCTAssertEqual(viewModel.options.count, 4)
    }
}
