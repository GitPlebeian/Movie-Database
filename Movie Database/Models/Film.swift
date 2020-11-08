//
//  Movie.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/4/20.
//

import UIKit


struct Film: Codable {
    let name: String?
    let popularity: Float
    let overview: String
    let releaseDate: String
    let posterPath: String?
    var poster: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case name = "title"
        case popularity
        case overview
        case releaseDate = "release_date"
    }
}

struct Results: Codable {
    let results: [Film]
}
