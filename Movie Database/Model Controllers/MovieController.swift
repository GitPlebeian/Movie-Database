//
//  MovieController.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/4/20.
//

import UIKit

enum BrowseSearches: String {
    case topMovies     = "/movie/top_rated"
    case popularMovies = "/movie/popular"
    case topTV         = "/tv/top_rated"
}

enum FilmSearch: String {
    case movie = "/search/movie"
    case tv    = "/search/tv"
}

class MovieController {
    
    // MARK: Shared
    
    static let shared = MovieController()
    
    // MARK: ENUMS
    
    // MARK: Properties
    
    private var browseFilms:    [Film] = []
    private var searchFilms:    [Film] = []
    private var browseFilmTask: URLSessionDataTask?
    private var searchFilmTask: URLSessionDataTask?
    
    // MARK: Browse Films
    
    // Get Browse Films
    func getBrowseFilms() -> [Film] {
        return browseFilms
    }
    
    // Empty Browse Films
    func emptyBrowseFilms() {
        browseFilms = []
    }
    
    // Get Browse Films
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
                let films = try decoder.decode(Results.self, from: data)
                self.browseFilms = films.results.compactMap {
                    return Film(film: $0)
                }
                completion(true)
            } catch let e {
                print(e)
            }
        }
        task.resume()
        browseFilmTask = task
    }
    
    // Cancel Browse Films Task
    func cancelBrowseFilmsTask() {
        browseFilmTask?.cancel()
    }
    
    // MARK: Search Films
    
    // Get Serach Films
    func getSearchFilms() -> [Film] {
        return searchFilms
    }
    
    // Empty Browse Films
    func emptySearchFilms() {
        searchFilms = []
    }
    
    // Get Search Films
    func getSearchFilmsFromServer(search: String, filmSearchType: FilmSearch, _ completion: @escaping (Bool) -> Void) {
        
        let urlString = Constants.primaryEndpointURL + filmSearchType.rawValue + "?api_key=" + Constants.apiKey + "&query=" + search
        
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
                let films = try decoder.decode(Results.self, from: data)
                self.searchFilms = films.results.compactMap {
                    return Film(film: $0)
                }
                completion(true)
            } catch let e {
                print(e)
            }
        }
        task.resume()
        searchFilmTask = task
    }
    
    // Cancel Search Films Task
    func cancelSearchFilmsTask() {
        searchFilmTask?.cancel()
    }
    
    // MARK: Helpers
    
    // MARK: Persistence
}
