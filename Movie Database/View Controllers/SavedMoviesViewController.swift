//
//  SavedMoviesViewController.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/4/20.
//

import UIKit

class SavedMoviesViewController: UIViewController {

    // MARK: Properties
    
    let selectionFeedback:     UISelectionFeedbackGenerator = UISelectionFeedbackGenerator()
    var savedFilms:            [Film] = []
    var shouldReloadTableView: Bool = true
    
    // MARK: Views
    
    @IBOutlet weak var filmTableView: UITableView!
    
    // MARK: Lifecycle
    
    // Did Load
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if shouldReloadTableView {
            savedFilms = MovieController.shared.getSavedFilms()
            filmTableView.reloadData()
        }
        if let indexPath = filmTableView.indexPathForSelectedRow {
            filmTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // Did Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shouldReloadTableView = true
    }
}

extension SavedMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    // Num rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedFilms.count
    }
    
    // Cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
        

        var film = savedFilms[indexPath.row]
        film.saved = true
        cell.delegate = self
        cell.configure(indexPath: indexPath,
                       film: film,
                       totalFilmCount: savedFilms.count,
                       filmIndex: indexPath.row)
        
        return cell
    }
    
    // Did Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let film = savedFilms[indexPath.row]
        guard let cell = tableView.cellForRow(at: indexPath)! as? MovieTableViewCell else {return}
        
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.film = film
        movieDetailViewController.posterImage = cell.posterImageView.image
        shouldReloadTableView = false
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

extension SavedMoviesViewController: MovieTableViewCellDelegate {
    
    // Favorite Button Tapped
    func favoriteButtonTapped(filmIndex: Int, saved: Bool) {
        selectionFeedback.selectionChanged()
        MovieController.shared.updateFilmSaved(film: savedFilms[filmIndex], saved: saved)
    }
}
