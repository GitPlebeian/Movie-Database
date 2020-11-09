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
    
    private var browseFilms:    [Film] = []
    private var browseFilmTask: URLSessionDataTask?
    
    // MARK: Public
    
    // Get Browse Films
    func getBrowseFilms() -> [Film] {
        return browseFilms
    }
    
    // Empty Browse Films
    func emptyBrowseFilms() {
        browseFilms = []
    }
    
    // Get Movies Test
    func getFilmsFromServer(search: BrowseSearches  = .topMovies, _ completion: @escaping (Bool) -> Void) {
        
        let urlString = Constants.primaryEndpointURL + search.rawValue + "?api_key=" + Constants.apiKey
        
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            if let error = error {
                if (error as NSError).code != NSURLErrorCancelled {
                    print("💩💩💩 Error finding movies: \(error)")
                    completion(false)
                }
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
        }
        task.resume()
        browseFilmTask = task
    }
    
    // Cancel Brose Films Task
    func cancelBrowseFilmsTask() {
        browseFilmTask?.cancel()
    }
    
    // MARK: Helpers
    
    // MARK: Persistence
}
