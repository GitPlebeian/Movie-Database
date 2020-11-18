//
//  FilmPersistence.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/17/20.
//

import Foundation

class FilmPersistence {
    
    // MARK: Shared
    
    static let shared = FilmPersistence()
    
    // MARK: Properties
    
    var savedFilms:       [Int: Film] = [:]
    var lastSelectedFilm: Film?
    
    // Is Film Saved
    func isFilmSaved(film: Film) -> Bool {savedFilms[film.id] != nil}
    
    // Save Updated
    func savedUpdated(film: Film, saved: Bool) {
        if saved {
            var filmToSave = film
            filmToSave.saved = true
            savedFilms[film.id] = filmToSave
        } else {
            savedFilms.removeValue(forKey: film.id)
        }
        sendSavedFilmsUpdatedNotification()
        saveFilms()
    }
    
    // Send Saved Films Updated Notification
    func sendSavedFilmsUpdatedNotification() {
        NotificationCenter.default.post(name: .savedMoviesUpdated, object: nil)
    }
    
    // Update Film Saved Values
    func updateFilmSavedValues(films: inout [Film]) {
        var newFilms: [Film] = []
        for film in films {
            var newFilm = film
            if isFilmSaved(film: film) {
                newFilm.saved = true
            } else {
                newFilm.saved = false
            }
            newFilms.append(newFilm)
        }
        films = newFilms
    }
    
    // MARK: Saved Films Persistence
    
    // Save Data
    func saveFilms() {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(savedFilms)
            try data.write(to: filmsFileURL())
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
            self.savedFilms = savedFilms
        } catch let error {
            print("Error loading last selected film: \(error)")
        }
    }
    
    // File URL
    func filmsFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = Constants.savedFilmsURL
        let fullURL = documentDirectory.appendingPathComponent(fileName)
        return fullURL
    }
}
