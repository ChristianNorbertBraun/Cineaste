//
//  MoviesViewControllerSnapshotTests.swift
//  CineasteSnapshotTests
//
//  Created by Felizia Bernutz on 17.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
import SnapshotTesting
import ReSwift
@testable import Cineaste_App

class MoviesViewControllerSnapshotTests: XCTestCase {

    func testEmptyAppearance() {
        // Given
        let viewController = MoviesViewController.instantiate()
        let navigationController = NavigationController(rootViewController: viewController)

        // When
        viewController.category = .watchlist

        // Then
        assertThemedNavigationSnapshot(matching: navigationController)
    }

    func testGeneralAppearanceForWatchlist() {
        // Given
        var state = AppState()
        state.movies = [
            Movie.testingWatchlistWithoutPosterPath,
            Movie.testingWatchlist2WithoutPosterPath
        ]
        store = Store(reducer: appReducer, state: state)

        let viewController = MoviesViewController.instantiate()
        let navigationController = NavigationController(rootViewController: viewController)

        // When
        viewController.category = .watchlist

        // Then
        assertThemedNavigationSnapshot(matching: navigationController)
    }

    func testGeneralAppearanceForHistory() {
        // Given
        var state = AppState()
        state.movies = [
            Movie.testingSeenWithoutPosterPath
        ]
        store = Store(reducer: appReducer, state: state)

        let viewController = MoviesViewController.instantiate()
        let navigationController = NavigationController(rootViewController: viewController)

        // When
        viewController.category = .seen

        // Then
        assertThemedNavigationSnapshot(matching: navigationController)
    }
}
