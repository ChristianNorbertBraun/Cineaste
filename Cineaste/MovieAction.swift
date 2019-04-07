//
//  MovieAction.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 07.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import ReSwift

enum MovieAction: Action {
    case load(movies: Set<Movie>)
    case add(movie: Movie)
    case update(movie: Movie)
    case delete(movie: Movie)
}
