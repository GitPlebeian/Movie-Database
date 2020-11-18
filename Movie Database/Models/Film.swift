//
//  Movie.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/4/20.
//

import UIKit


struct Film: Codable {
    let id:           Int
    let title:        String?
    let name:         String?
    let overview:     String
    let releaseDate:  String?
    let firstAirDate: String?
    let posterPath:   String?
    let backdropPath: String?
    var saved:        Bool = false
    
    init?(film: Film) {
        if film.posterPath == nil ||
            film.overview == "" ||
            (film.title == nil && film.name == nil) ||
            (film.releaseDate == nil && film.firstAirDate == nil) {
            return nil
        }
        self.id           = film.id
        self.title        = film.title
        self.name         = film.name
        self.overview     = film.overview
        self.releaseDate  = film.releaseDate
        self.firstAirDate = film.firstAirDate
        self.posterPath   = film.posterPath
        self.backdropPath = film.backdropPath
        self.saved        = film.saved
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title = "title"
        case name = "name"
        case overview
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case backdropPath = "backdrop_path"
    }
}

struct FilmAPIResults: Codable {
    let films: [Film]
    
    enum CodingKeys: String, CodingKey {
        case films = "results"
    }
}


