//
//  MovieController.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/4/20.
//

import UIKit

enum BrowseSearches: String, CaseIterable {
    case topMovies     = "/movie/top_rated"
    case popularMovies = "/movie/popular"
    case topTV         = "/tv/top_rated"
}

class MovieController {
    
    // MARK: Shared
    
    static let shared = MovieController()
    
    // MARK: ENUMS
    
    
    // MARK: Properties
    
    var browseFilms: [Film] = []
    
    // MARK: Public
    
    // Get Movies Test
    func getFilms(search: BrowseSearches  = .topMovies, completion: @escaping (Bool) -> Void) {
        let urlString = Constants.primaryEndpointURL + search.rawValue + "?api_key=" + Constants.apiKey
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("💩💩💩 Error finding movies: \(error)")
                completion(false)
                return
            }
            
            guard let data = data else {
                completion(false)
                return
            }
            do {
                let decoder = JSONDecoder()
                let film = try decoder.decode(Results.self, from: data)
                self.browseFilms = film.results
                completion(true)
            } catch let e {
                print(e)
            }
        }.resume()
    }
    
    // Get Movie Image
    func getMovieImage(index: Int, completion: @escaping () -> Void) {
        let filmImage = browseFilms[index].posterPath
        let url = "https://image.tmdb.org/t/p/w500/" + filmImage!
        
        guard let finalURL = URL(string: url) else {
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("💩💩💩 Error finding film image: \(error)")
                self.browseFilms[index].poster = UIImage(named: "No Film Image")
                completion()
                return
            }
            
            guard let data = data else {
                self.browseFilms[index].poster = UIImage(named: "No Film Image")
                completion()
                return
            }
            
            if let image = UIImage(data: data) {
                self.browseFilms[index].poster = image
            } else {
                self.browseFilms[index].poster = UIImage(named: "No Film Image")
            }
            completion()
        }.resume()
    }
    
    // MARK: Helpers
    
    // MARK: Persistence
}
