//
//  SearchMoviesViewController+3DTouch.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 21.07.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

extension SearchMoviesViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {

        guard let path = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: path)
            else { return nil }

        let movie = movies[path.row]
        let currentState = watchStates[movie] ?? .undefined

        previewingContext.sourceRect = cell.frame

        let detailVC = MovieDetailViewController.instantiate()
        detailVC.configure(with: .network(movie),
                           state: currentState)
        detailVC.hidesBottomBarWhenPushed = true
        return detailVC
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit,
                                                 animated: true)
    }
}
