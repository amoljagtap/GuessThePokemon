//
//  BaseService.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 24/12/2024.
//

import Combine

/// A base protocol that defines a service with an HTTP request dispatcher dependency.
protocol BaseService {
    /// HTTP client responsible for executing network requests.
    var httpClient: HTTPRequestDispatcher { get }
}
