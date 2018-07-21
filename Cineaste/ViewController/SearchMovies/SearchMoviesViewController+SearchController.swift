//
//  SearchMoviesViewController+SearchController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 21.07.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

extension SearchMoviesViewController: UISearchResultsUpdating {
    internal func updateSearchResults(for searchController: UISearchController) {
        //reset pagination
        currentPage = nil
        totalResults = nil

        searchDelayTimer?.invalidate()
        searchDelayTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] _ in
            self?.loadMovies(forQuery: searchController.searchBar.text) { movies in
                self?.movies = movies
            }
        }
    }
}
