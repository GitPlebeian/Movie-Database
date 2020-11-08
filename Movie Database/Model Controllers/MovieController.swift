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
    
    var browseFilms: [Film] = []
    
    // MARK: Public
    
    // Get Movies Test
    func getMoviesTest(completion: @escaping (Bool) -> Void) {
        let apiKey = "c17812157d6de4d9c61efdf69042bbce"
        let defaultURL = "https://api.themoviedb.org/3/movie/popular?api_key="
        
        guard let url = URL(string: defaultURL + apiKey) else {
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
                if Int.random(in: 0...1) == 0 {
                    self.browseFilms[index].poster = UIImage(named: "No Film Image")
                } else {
                    self.browseFilms[index].poster = image
                }
            } else {
                self.browseFilms[index].poster = UIImage(named: "No Film Image")
            }
            completion()
        }.resume()
    }
    
    // MARK: Helpers
    
    // MARK: Persistence
}
