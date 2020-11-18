//
//  MovieController.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/4/20.
//

import UIKit

class MovieController {
    
    // MARK: Shared
    
    static let shared = MovieController()
    
    // MARK: Properties
    
    private var lastSelectedFilm: Film? // Used for "5. When the app is closed, the app remembers the last selected feature and opens with that as the default view. If it is the first time, open with “Top rated movies” or anything of your preference."
    
    // Get Browse Films
//    func getBrowseFilmsFromServer(search: BrowseSearches  = .topMovies, _ completion: @escaping (Bool) -> Void) {
        
//        let urlString = Constants.primaryEndpointURL + search.rawValue + "?api_key=" + Constants.apiKey
//
//        guard let url = URL(string: urlString) else {
//            completion(false)
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
//
//            if let error = error {
//                if (error as NSError).code != NSURLErrorCancelled {
//                    print("💩💩💩 Error finding movies: \(error)")
//                    completion(false)
//                }
//                return
//            }
//
//            guard let data = data else {
//                completion(false)
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let results = try decoder.decode(GetFilmsAPIResults.self, from: data)
//                completion(true)
//            } catch let e {
//                print(e)
//            }
//        }
//        task.resume()
//        browseFilmTask = task
//    }
    
    // Cancel Browse Films Task
    func cancelBrowseFilmsTask() {
//        browseFilmTask?.cancel()
    }
    
    // Browse Film Save Updated
    func browseFilmSaveUpdated(filmIndex: Int, saved: Bool) {
//        browseFilms[filmIndex].saved = saved
//        updateFilmSaved(film: browseFilms[filmIndex], saved: saved)
    }
    
    // MARK: Search Films
    
    // Get Serach Films
//    func getSearchFilms() -> [Film] {searchFilms}
//
//    // Empty Browse Films
//    func emptySearchFilms() {searchFilms = []}
    
    // Get Search Films
//    func getSearchFilmsFromServer(search: String, filmSearchType: FilmSearch, _ completion: @escaping (Bool) -> Void) {
        
//        let urlString = Constants.primaryEndpointURL + filmSearchType.rawValue + "?api_key=" + Constants.apiKey + "&query=" + search
//
//        guard let url = URL(string: urlString) else {
//            completion(false)
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
//
//            if let error = error {
//                if (error as NSError).code != NSURLErrorCancelled {
//                    print("💩💩💩 Error finding movies: \(error)")
//                    completion(false)
//                }
//                return
//            }
//
//            guard let data = data else {
//                completion(false)
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let results = try decoder.decode(GetFilmsAPIResults.self, from: data)
//                self.searchFilms = results.films.compactMap { // Use compact map and the Film.init? so that we only get the more "popular/famous" films
//                    guard var film = Film(film: $0) else {return nil}
//                    film.saved = self.isFilmSaved(film: film)
//                    return film
//                }
//                completion(true)
//            } catch let error {
//                print("Error decoding films in \(#function) \(error)")
//            }
//        }
//        task.resume()
//        searchFilmTask = task
//    }
    
    // Cancel Search Films Task
//    func cancelSearchFilmsTask() {
//        searchFilmTask?.cancel()
//    }
    
    // Search Films Save Updated
    func searchFilmSaveUpdated(filmIndex: Int, saved: Bool) {
//        searchFilms[filmIndex].saved = saved
//        updateFilmSaved(film: searchFilms[filmIndex], saved: saved)
    }
    
    // MARK: Saved Films
    
    // Get Saved Films
    func getSavedFilms() -> [Film] {
//        var films: [Film] = []
//        for (_, value) in savedFilms {
//            films.append(value)
//        }
//        return films
        return []
    }
    
    func updateFilmSaved(film: Film, saved: Bool) {
//        browseFilms = browseFilms.map {
//            if $0.id == film.id {
//                var newFilm = $0
//                newFilm.saved = saved
//                return newFilm
//            }
//            return $0
//        }
//        searchFilms = searchFilms.map {
//            if $0.id == film.id {
//                var newFilm = $0
//                newFilm.saved = saved
//                return newFilm
//            }
//            return $0
//        }
        if saved {
            var filmToSave = film
            filmToSave.saved = true
//            savedFilms[film.id] = filmToSave
        } else {
//            savedFilms.removeValue(forKey: film.id)
        }
        saveFilms()
    }
    
    // Is Film Saved
//    private func isFilmSaved(film: Film) -> Bool {savedFilms[film.id] != nil}
    
    // MARK: Saved Films Persistence
    
    // Save Data
    func saveFilms() {
        let jsonEncoder = JSONEncoder()
        do {
//            let data = try jsonEncoder.encode(savedFilms)
//            try data.write(to: filmsFileURL())
        } catch let e {
            print(e)
        }
    }
    
    // Load Data
    func loadFilms() {
        do {
            let data = try Data(contentsOf: filmsFileURL())
            let jsonDecoder = JSONDecoder()
            let savedFilms = try jsonDecoder.decode([Int: Film].self, from: data)
//            self.savedFilms = savedFilms
        } catch let error {
            print("Error loading last selected film: \(error)")
        }
    }
    
    // File URL
    func filmsFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = "savedFilms.json"
        let fullURL = documentDirectory.appendingPathComponent(fileName)
        return fullURL
    }
    
    // MARK: Last Selected Film
    
    // Get
    func getLastSelectedFilm() -> Film? {lastSelectedFilm}
    
    // Set
    func setLastSelectedFilm(film: Film) {
        lastSelectedFilm = film
        saveLastSelectedFilm()
    }
    
    // Save Data
    func saveLastSelectedFilm() {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(lastSelectedFilm)
            try data.write(to: lastSelectedFilmURL())
        } catch let e {
            print(e)
        }
    }
    
    // Load Data
    func loadLastSelectedFilm() {
        do {
            let data = try Data(contentsOf: lastSelectedFilmURL())
            let jsonDecoder = JSONDecoder()
            let lastSelectedFilm = try jsonDecoder.decode(Film.self, from: data)
            self.lastSelectedFilm = lastSelectedFilm
        } catch let error {
            print("Error loading last selected film: \(error)")
        }
    }
    
    // File URL
    func lastSelectedFilmURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = "lastSelectedFilm.json"
        let fullURL = documentDirectory.appendingPathComponent(fileName)
        return fullURL
    }
}
