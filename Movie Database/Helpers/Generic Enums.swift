//
//  Global Enums.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/17/20.
//

import Foundation

enum ImageLoadingError: Error {
    case dataConvert
}

extension ImageLoadingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dataConvert:
            return NSLocalizedString("Description of data convert error", comment: "Unable to convert data to image.")
        }
    }
}

enum GenericNetworkError: Error {
    case urlCreation
}


enum BrowseSearches: String {
    case topMovies     = "/movie/top_rated"
    case popularMovies = "/movie/popular"
    case topTV         = "/tv/top_rated"
}

enum FilmSearch: String {
    case movie = "/search/movie"
    case tv    = "/search/tv"
}

extension Notification.Name {
    static let savedMoviesUpdated = Notification.Name("Saved Movies Updated")
}
