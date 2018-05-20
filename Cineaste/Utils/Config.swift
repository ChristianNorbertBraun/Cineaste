//
//  Config.swift
//  Cineaste
//
//  Created by Christian Braun on 21.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

struct Config {
    struct Backend {
        static let url = "https://api.themoviedb.org/3"
        static let posterUrl = "https://image.tmdb.org/t/p/w342"
    }

    struct UserDefaults {
        static let usernameKey = "cineaste-username"
    }
}
