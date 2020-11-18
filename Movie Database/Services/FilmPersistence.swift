//
//  FilmPersistence.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/17/20.
//

import Foundation

class FilmPersistence {
    
    // MARK: Shared
    
    static let shared = FilmPersistence()
    
    // MARK: Properties
    
    var savedFilms:       [Int: Film] = [:]
    var lastSelectedFilm: Film?
    
    // Is Film Saved
    func isFilmSaved(film: Film) -> Bool {savedFilms[film.id] != nil}
    
}
