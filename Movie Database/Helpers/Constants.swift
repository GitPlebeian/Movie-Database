//
//  Constants.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/7/20.
//

import Foundation

struct Constants {
    static let apiKey = "c17812157d6de4d9c61efdf69042bbce"
    static let primaryEndpointURL = "https://api.themoviedb.org/3"
    static let imageEndpointURL = "https://image.tmdb.org/t/p/"
}

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
