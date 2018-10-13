//
//  MovieMatchViewController+UITableView.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 21.07.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

extension MovieMatchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesWithNumber.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieMatchCell = tableView.dequeueCell(identifier: MovieMatchCell.identifier)

        let movieWithNumber = moviesWithNumber[indexPath.row]
        cell.configure(with: movieWithNumber.0,
                       numberOfMatches: movieWithNumber.1,
                       amountOfPeople: totalNumberOfPeople,
                       delegate: self)

        return cell
    }
}
