//
//  SearchMoviesViewController+UITableView.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 03.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension SearchMoviesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard indexPaths.first(where: { $0.isLast(of: moviesWithWatchStates.count) }) != nil,
            let total = totalResults
            else { return }

        if total > moviesWithWatchStates.count && !isLoadingNextPage {
            tableView.tableFooterView = loadingIndicatorView
            isLoadingNextPage = true

            loadMovies(forQuery: resultSearchController.searchBar.text, nextPage: true) { movies in
                DispatchQueue.main.async {
                    self.moviesFromNetworking.formUnion(movies)
                    self.isLoadingNextPage = false
                }
            }
        }
    }
}

extension SearchMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = moviesWithoutWatchState[indexPath.row]
        store.dispatch(SelectionAction.select(movie: selectedMovie))
        perform(segue: .showMovieDetail, sender: self)
    }
}

extension SearchMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesWithWatchStates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchMoviesCell = tableView.dequeueCell(identifier: SearchMoviesCell.identifier)

        let movie = moviesWithoutWatchState[indexPath.row]
        let currentState = moviesWithWatchStates[movie] ?? .undefined

        cell.configure(with: moviesWithoutWatchState[indexPath.row], state: currentState)

        if let numberOfMovies = totalResults,
            indexPath.isLast(of: numberOfMovies) {
            tableView.tableFooterView = UIView()
        }

        return cell
    }
}
