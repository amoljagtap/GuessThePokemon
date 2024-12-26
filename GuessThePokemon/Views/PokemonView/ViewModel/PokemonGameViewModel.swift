//
//  PokemonGameViewModel.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

// PokemonGameViewModel.swift

import Combine
import SwiftUI

final class PokemonGameViewModel: ObservableObject {
    
    enum PokemonGameViewState: Equatable {
        case loading
        case gameStarted
        case nextPokemon
        case gameOver
        case error(String)
    }
    
    /// Current view state, Default is Loading
    @Published var viewState: PokemonGameViewState = .loading
    /// Score count of the game
    @Published var score: Int = 0
    /// Remaining pokemon characters left to guess
    @Published var remainingCharacters = 10
    /// Reveals answer when set to true. Default is false
    @Published var showAnswer = false
    /// Currently displayed pokemon character
    @Published var currentCharacter: PokemonCharacterDetail?
    /// Options to guess the currently displayed character
    @Published var options: [PokemonGameOption] = []
    /// Answer index of the current pokemon character
    @Published var totalCharactersPerGame: Int = 10
    
    /// Image Url of the current pokemon character
    var currentCharacterImageUrl: URL? {
        guard let urlString = currentCharacter?.frontDefault,
              let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    /// Answer index of the current pokemon character
    var correctAnswerIndex: Int? {
        return options.firstIndex { $0.isCorrect == true}
    }
    
    // MARK: - Dependencies
    /// Store subscribers reference for memory management
    private var cancellable = Set<AnyCancellable>()
    /// Pokemon service for fetching pokemon data
    private let pokemonService: PokemonServiceProviding
    /// Pokemon service for fetching pokemon image
    private let pokemonCharacterImageService: PokemonCharacterImageServiceProviding
    /// Array of pokemon characters
    private(set) var pokemonCharacterDetails: [PokemonCharacterDetail] = []
    /// Pagination data set for fetching pokemon data in batches
    private(set) var pagination = Pagination()
    /// Boolean to indiacate game status. Default is false
    private var hasGameStarted = false

    // MARK: - Initialization
    init(pokemonService: PokemonServiceProviding,
         pokemonCharacterImageService: PokemonCharacterImageServiceProviding) {
        self.pokemonService = pokemonService
        self.pokemonCharacterImageService = pokemonCharacterImageService
    }
    
    /// Starts a new pokemon game if game data is available
    /// Otherwise fetch the latest data and then starts a new game
    func loadGame() {
        if !hasGameStarted {
            updateViewState(.loading)
            fetchGameData()
        } else {
            startNewGame()
        }
    }
    
    // MARK: - Public Methods
    /// Reset game data model and starts a new game
    func startNewGame() {
        resetGame()
        startGame()
    }
    
    /// Update view state to the given new state
    /// - Parameter state: view state object
    func updateViewState(_ state: PokemonGameViewState) {
        viewState = state
    }
    
    /// Select a random pokemon character from list of pokemon characters.
    /// Update the options based on the new selected character and view state
    func selectRandomPokemonCharacter() {
        guard let selectedCharacter = pokemonCharacterDetails.randomElement() else { return }
        currentCharacter = selectedCharacter
        options = generateOptions(for: selectedCharacter)
        showAnswer = false
        updateViewState(.gameStarted)
    }
    
    /// Update game score based on the answer
    /// - Parameter isCorrect: boolean indiacate if the answer is correct
    func updateGameScore(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            score += 1
        }
        showAnswer = true
        remainingCharacters -= 1
        if remainingCharacters == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.updateViewState(.gameOver)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.updateViewState(.nextPokemon)
            }
        }
    }
    
    /// Reveals the answer and update the game score based on the user selected option
    /// - Parameter selectedIndex: Index of selected option
    func revealAnswer(selectedIndex: Int) {
        let isCorrect = isCorrectOptionSelected(selectedIndex: selectedIndex)
        updateGameScore(isCorrectAnswer: isCorrect)
    }
    
    /// Retruns true if correct answer index is selected
    /// - Parameter selectedIndex: user selected answer index from the options
    /// - Returns: returns true if answer is correct
    func isCorrectOptionSelected(selectedIndex: Int) -> Bool {
        return options[selectedIndex].isCorrect
    }
    
    // MARK: - Private Methods
    private func startGame() {
        remainingCharacters = totalCharactersPerGame
        selectRandomPokemonCharacter()
        updateViewState(.gameStarted)
    }
    
    private func generateOptions(for character: PokemonCharacterDetail) -> [PokemonGameOption] {
        let randomOptions = pokemonCharacterDetails.randomElements(count: 3, excluding: character).map {
            PokemonGameOption(name: $0.name, isCorrect: false)
        }
        let correctOption = PokemonGameOption(name: character.name, isCorrect: true)
        var allOptions = randomOptions + [correctOption]
        allOptions.shuffle()
        return allOptions
    }
    
    private func resetGame() {
        score = 0
        showAnswer = false
        hasGameStarted = false
    }
    
    /// Fetches game data
    private func fetchGameData() {
        pokemonService.fetchPokemon(pagination: pagination)
            .flatMap { [weak self] pokemon -> AnyPublisher<[PokemonCharacterDetail], HTTP.ApiError> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                return pokemonService.fetchPokemonCharacterDetails(pokemons: pokemon.results)
            }
            .flatMap { [weak self] characterDetails -> AnyPublisher<[(Data, URL?)], HTTP.ApiError> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                pokemonCharacterDetails.append(contentsOf: characterDetails)
                pagination.offset = pokemonCharacterDetails.count
                return pokemonCharacterImageService.fetchPokemonCharacterImage(characters: characterDetails)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print("error: \(error.localizedDescription)")
                    self?.hasGameStarted = false
                    self?.updateViewState(.error(PokemonGameError.fetchFailed.localizedDescription))
                }
            } receiveValue: { [weak self] images in
                guard let self = self else { return }
                ImageCache.cache(images: images)
                if !hasGameStarted {
                    startNewGame()
                    hasGameStarted = true
                }
                if pagination.hasNextPage {
                    pagination.nextPage()
                    fetchGameData()
                }
            }
            .store(in: &cancellable)
    }
}
