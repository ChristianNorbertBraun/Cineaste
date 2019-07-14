//
//  SearchMoviesViewController+SwipeHint.swift
//  Cineaste App
//
//  Created by Wolfgang Timme on 7/14/19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit

extension SearchMoviesViewController {
    func animateSwipeActionHint() {
        if let cell = tableView.visibleCells.first as? SearchMoviesCell {
            cell.animateSwipeHint()
        }
    }
}
