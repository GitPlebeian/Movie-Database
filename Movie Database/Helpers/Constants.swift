//
//  Constants.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/7/20.
//

import Foundation

struct Constants {
    static let apiKey             = "c17812157d6de4d9c61efdf69042bbce"
    static let movieHost          = "api.themoviedb.org"
    static let imageHost          = "https://image.tmdb.org"
    static let savedFilmsURL      = "savedFilms.json"
    static let lastSavedFilmURL   = "lastSelectedFilm.json"
}

struct QueryKeys {
    // For Getting Films From Database
    static let api = "api_key"
    static let filmSearch = "query"
}
