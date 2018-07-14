//
//  Config.swift
//  Cineaste
//
//  Created by Christian Braun on 21.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

enum Config {
    enum Backend {
        static let url = "https://api.themoviedb.org/3"
        static let posterUrl = "https://image.tmdb.org/t/p/w342"
        static let posterUrlOriginal = "https://image.tmdb.org/t/p/original"
        static let shareMovieUrl = "https://www.themoviedb.org/movie/"
    }

    enum UserDefaults {
        static let usernameKey = "cineaste-username"
    }
}
