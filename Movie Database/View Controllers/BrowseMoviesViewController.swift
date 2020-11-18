//
//  BrowseMoviesViewController.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/4/20.
//

import UIKit

class BrowseMoviesViewController: UIViewController {

    // MARK: Properties
    
    var films:                 [Film] = []
    var getFilmsDataTask:      URLSessionDataTask?
    let selectionFeedback:     UISelectionFeedbackGenerator = UISelectionFeedbackGenerator()
    var shouldReloadTableView: Bool = true // We don't want the table view to be reloaded when we come back from a MovieDetailViewController
    
    // MARK: Views
    
    @IBOutlet weak var filmTableView:                  UITableView!
    weak var           filmTableViewRefreshController: UIRefreshControl!
    @IBOutlet weak var filmCategorySegmentedControl:   UISegmentedControl!
    
    // MARK: Lifecycle
    
    // Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getNewFilms()
        
        if let film = FilmPersistence.shared.getLastSelectedFilm() {
            let movieDetailViewController = MovieDetailViewController()
            movieDetailViewController.film = film
            present(movieDetailViewController, animated: false, completion: nil)
        }
        
        // Add Observers
        NotificationCenter.default.addObserver(self, selector: #selector(savedFilmsUpdated), name: .savedMoviesUpdated, object: nil)
    }
    
    // Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if shouldReloadTableView {
            filmTableView.reloadData() // We don't want the table view to be reloaded when we come back from a MovieDetailViewController
        }
        if let indexPath = filmTableView.indexPathForSelectedRow {
            filmTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // Did Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shouldReloadTableView = true // We don't want the table view to be reloaded when we come back from a MovieDetailViewController
    }
    
    // MARK: Actions
    
    // Film Category Changed
    @IBAction func filmCategoryChanged(_ sender: UISegmentedControl) {
        getNewFilms()
    }
    
    // Table View Refreshed
    @objc func tableViewRefreshed() {
        films = []
        filmTableView.reloadData()
        getNewFilms()
    }
    
    // Saved Films Updated
    @objc func savedFilmsUpdated() {
        FilmPersistence.shared.updateFilmSavedValues(films: &films)
    }
    
    // MARK: Helpers
    
    // Get New Films
    func getNewFilms() {
        var search: BrowseSearches
        switch filmCategorySegmentedControl.selectedSegmentIndex {
        case 0: search = .topMovies
        case 1: search = .popularMovies
        case 2: search = .topTV
        default:
            presentBasicAlert(title: "Uh-Oh!", message: "Unable to search for movies. Please contact dev team.")
            return
        }
        getFilmsDataTask?.cancel()
        self.getFilmsDataTask = FilmNetworkRequests.getConfiguredFilms(search: nil, searchType: search) { [weak self] (result) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                do {
                    self.films = try result.get()
                    self.filmTableViewRefreshController.endRefreshing()
                    self.filmTableView.reloadData()
                } catch let error {
                    self.presentBasicAlert(title: "Oh-Oh!", message: error.localizedDescription)
                }
            }
        }
    }
    
    // Present Basic Alert
    func presentBasicAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    // MARK: Setup Views
    
    func setupViews() {
        // Adds refresh controller
        let filmTableViewRefreshController = UIRefreshControl()
        filmTableViewRefreshController.addTarget(self, action: #selector(tableViewRefreshed), for: .valueChanged)
        filmTableView.addSubview(filmTableViewRefreshController)
        self.filmTableViewRefreshController = filmTableViewRefreshController
        filmTableView.sendSubviewToBack(filmTableViewRefreshController)
    }
}

// MARK: Table View

extension BrowseMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Num rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    // Cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
        
        let film = films[indexPath.row]
        
        cell.delegate = self
        cell.configure(indexPath: indexPath,
                       film: film,
                       totalFilmCount: films.count,
                       filmIndex: indexPath.row)
        
        return cell
    }
    
    // Did Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let film = films[indexPath.row]
        guard let cell = tableView.cellForRow(at: indexPath)! as? MovieTableViewCell else {return}
        
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.film = film
        movieDetailViewController.posterImage = cell.posterImageView.image
        shouldReloadTableView = false
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

extension BrowseMoviesViewController: MovieTableViewCellDelegate {
    
    // Favorite Button Tapped
    func favoriteButtonTapped(filmIndex: Int, saved: Bool) {
        selectionFeedback.selectionChanged()
        FilmPersistence.shared.savedUpdated(film: films[filmIndex], saved: saved)
    }
}
