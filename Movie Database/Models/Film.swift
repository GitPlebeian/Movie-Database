//
//  Movie.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/4/20.
//

import UIKit


struct Film: Codable {
    let title: String?
    let name: String?
    let popularity: Float
    let overview: String
    let releaseDate: String?
    let firstAirDate: String?
    var posterPath: String?
    var backdropPath: String?
    var posterImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case title = "title"
        case name = "name"
        case popularity
        case overview
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case backdropPath = "backdrop_path"
    }
}

struct Results: Codable {
    let results: [Film]
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case results
        case totalResults = "total_results"
    }
}


