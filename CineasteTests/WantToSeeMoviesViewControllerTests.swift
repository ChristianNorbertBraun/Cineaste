//
//  WantToSeeMoviesViewControllerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste

class WantToSeeMoviesViewControllerTests: XCTestCase {
    let wantToSeeMoviesVC = WantToSeeMoviesViewController.instantiate()

    func testViewDidLoad() {
        wantToSeeMoviesVC.viewDidLoad()

        XCTAssertNotNil(wantToSeeMoviesVC.fetchedResultsManager.delegate)
    }

}
