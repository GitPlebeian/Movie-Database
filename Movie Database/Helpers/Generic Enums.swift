//
//  Global Enums.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/17/20.
//

import Foundation

// MARK: Notification.Name

extension Notification.Name {
    static let savedMoviesUpdated = Notification.Name("Saved Movies Updated")
}

// MARK: Image Loading Error

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

// MARK: Generic Network Error

enum GenericNetworkError: Error {
    case urlCreation
}

extension GenericNetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .urlCreation:
            return NSLocalizedString("Description of url creation error", comment: "Unable to creation a valid url.")
        }
    }
}

// MARK: URL Session Error

enum URLSessionError: Error {
    case dataNotProvided
}

extension URLSessionError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dataNotProvided:
            return NSLocalizedString("Description of data not provided", comment: "Data not provided by server.")
        }
    }
}

// MARK: Film Related

enum BrowseSearches: String {
    case topMovies     = "/movie/top_rated"
    case popularMovies = "/movie/popular"
    case topTV         = "/tv/top_rated"
}

enum FilmSearch: String {
    case movie = "/search/movie"
    case tv    = "/search/tv"
}
