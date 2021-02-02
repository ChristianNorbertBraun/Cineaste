//
//  ImporterTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 26.12.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import XCTest
import ReSwift
@testable import Cineaste_App

class ImporterTests: XCTestCase {

    func testImportMoviesFromUrlShouldImportMovies() {
        XCTAssertNoThrow(
            try cleanImportOfMovies(
                from: "Import",
                expectedNumberOfMovies: 2
            )
        )
    }

    func testImportMoviesFromUrlShouldImportMoviesFromAndroidExport() {
        XCTAssertNoThrow(
            try cleanImportOfMovies(
                from: "AndroidExport",
                expectedNumberOfMovies: 3
            )
        )
    }

    func testImportMoviesFromUrlShouldResultInErrorWhenImportingFailingJson() {
        // Given
        guard let path = Bundle(for: ImporterTests.self)
            .path(forResource: "FailingImport", ofType: "json")
            else {
                fatalError("Could not load file for resource FailingImport.json")
        }
        let urlToFailingImport = URL(fileURLWithPath: path)
        var actions: [MovieAction] = []
        store.dispatchFunction = { action in
            if let action = action as? MovieAction {
                actions.append(action)
            }
        }
        let exp = XCTestExpectation(description: "Waiting for movies to import")

        // When
        var error: ImportError?
        Importer.importMovies(from: urlToFailingImport) { result in
            error = result.error
            exp.fulfill()
        }

        // Then
        wait(for: [exp], timeout: 5)
        XCTAssertNotNil(error)
        XCTAssertEqual(actions.count, 0)
    }
}

extension ImporterTests {
    private func cleanImportOfMovies(from file: String, expectedNumberOfMovies: Int) throws {
        // Given
        guard let path = Bundle(for: ImporterTests.self)
            .path(forResource: file, ofType: "json")
            else {
                fatalError("Could not load file for resource \(file).json")
        }
        let urlToImport = URL(fileURLWithPath: path)
        var actions: [MovieAction] = []
        store.dispatchFunction = { action in
            if let action = action as? MovieAction {
                actions.append(action)
            }
        }
        let exp = XCTestExpectation(description: "Waiting for movies to import")

        // When
        var amountOfImportedMovies: Int?
        Importer.importMovies(from: urlToImport) { result in
            amountOfImportedMovies = result.value!
            exp.fulfill()
        }

        // Then
        wait(for: [exp], timeout: 5)
        XCTAssertEqual(amountOfImportedMovies, expectedNumberOfMovies)
        XCTAssertEqual(actions.count, expectedNumberOfMovies * 2)

        // because it's irrelevant what movie is included in the action,
        // we just check the start of the string which describes the action
        for (index, action) in actions.enumerated() {

            // the first half of actions is a "add movie action",
            // the second half is a "update movie action"
            let beginningOfAction = index < actions.count / 2
                ? "add(movie: Cineaste_App.Movie("
                : "update(movie: Cineaste_App.Movie("

            XCTAssert(
                String(describing: action).starts(with: beginningOfAction)
            )
        }
    }
}

extension Result {
    var value: Success? {
        switch self {
        case .success(let value):
            return value
        default:
            return nil
        }
    }

    var error: Failure? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
}
