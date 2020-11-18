//
//  FilmNetworkRequests.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/17/20.
//

import Foundation

enum GetFilmsError: Error {
    case dataConvert
}

extension GetFilmsError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dataConvert:
            return NSLocalizedString("Description of data convert error", comment: "Unable to convert provided data to films.")
        }
    }
}

class FilmNetworkRequests {
    
    // MARK: Get Raw Films
    
    static func getRawFilms(search: (String, FilmSearch)?, searchType: BrowseSearches = .topMovies, _ completion: @escaping (Result<[Film], Error>) -> Void) -> URLSessionDataTask? {
        // Create a url
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constants.movieHost
        if let search = search {
            components.path = "/3" + search.1.rawValue
            components.queryItems = [
                URLQueryItem(name: QueryKeys.filmSearch, value: search.0),
                URLQueryItem(name: QueryKeys.api, value: Constants.apiKey)
            ]
        } else {
            components.path = "/3" + searchType.rawValue
            components.queryItems = [
                URLQueryItem(name: QueryKeys.api, value: Constants.apiKey)
            ]
        }
        guard let url = components.url else {
            print("💩💩💩 Unable to get a valid url from URLComponents in \(#function) | File: \(#file) | Line: \(#line)")
            completion(.failure(GenericNetworkError.urlCreation))
            return nil
        }
        
        // Create and resume the dataTask
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                if (error as NSError).code != NSURLErrorCancelled {
                    print("💩💩💩 Error getting films in \(#function) | File: \(#file) | Line: \(#line) \(error)")
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                completion(.failure(URLSessionError.dataNotProvided))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let results = try decoder.decode(FilmAPIResults.self, from: data)
                completion(.success(results.films))
            } catch {
                print("💩💩💩 Unable to decode data to film results in \(#function)")
                completion(.failure(GetFilmsError.dataConvert))
                return
            }
        }
        task.resume()
        return task
    }
    
    // MARK: Get Configured Films
    
    /// Gets only films that are "popular" and contain values I want in my movie browsing
    static func getConfiguredFilms(search: (String, FilmSearch)?, searchType: BrowseSearches = .topMovies, _ completion: @escaping (Result<[Film], Error>) -> Void) -> URLSessionDataTask? {
        let task = getRawFilms(search: search, searchType: searchType) { (result) in
            do {
                var films = try result.get()
                films = films.compactMap {
                    guard var film = Film(film: $0) else {return nil}
                    film.saved = FilmPersistence.shared.isFilmSaved(film: film)
                    return film
                }
                completion(.success(films))
            } catch let error {
                print("💩💩💩 Error loading image in \(#function) \(error)")
                completion(.failure(error))
            }
        }
        return task
    }
}
