//
//  SearchMoviesViewController.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/4/20.
//

import UIKit

class SearchMoviesViewController: UIViewController {
    
    // MARK: Properties

    var films:                 [Film] = []
    var getFilmsDataTask:      URLSessionDataTask?
    let searchController =     UISearchController(searchResultsController: nil)
    let selectionFeedback:     UISelectionFeedbackGenerator = UISelectionFeedbackGenerator()
    var shouldReloadTableView: Bool = true

    // MARK: Views

    @IBOutlet var filmTableView: UITableView!


    // MARK: Lifecycle

    // Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        // Add Observers
        NotificationCenter.default.addObserver(self, selector: #selector(savedFilmsUpdated), name: .savedMoviesUpdated, object: nil)
    }

    // Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if shouldReloadTableView {
            filmTableView.reloadData()
        }
        if let indexPath = filmTableView.indexPathForSelectedRow {
            filmTableView.deselectRow(at: indexPath, animated: true)
        }
        dismiss(animated: false, completion: nil) // De-focuses the search field
    }

    // Did Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shouldReloadTableView = true
    }
    
    // MARK: Actions
    
    // Saved Films Updated
    @objc func savedFilmsUpdated() {
        FilmPersistence.shared.updateFilmSavedValues(films: &films)
    }

    //MARK: Helpers

    // Present Basic Alert
    func presentBasicAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }

    // MARK: Setup Views

    func setupViews() {
        self.view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Films"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = ["Movies", "Tv"]
    }
}

extension SearchMoviesViewController: UITableViewDelegate, UITableViewDataSource {

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

extension SearchMoviesViewController: UISearchResultsUpdating {

    // Update Search Results
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar

        guard let searchText = searchBar.text, searchText != "" else {return}

        var filmSearchType: FilmSearch
        if searchBar.selectedScopeButtonIndex == 0 {
            filmSearchType = .movie
        } else {
            filmSearchType = .tv
        }

        getFilmsDataTask?.cancel() // Cancel any existing calls, we do this because people can type fast in the search bar and we don't want 10 pending calls all to be completed at once
        self.getFilmsDataTask = FilmNetworkRequests.getConfiguredFilms(search: (searchText, filmSearchType)) { [weak self] (result) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                do {
                    self.films = try result.get()
                    self.filmTableView.reloadData()
                } catch let error {
                    self.presentBasicAlert(title: "Oh-Oh!", message: error.localizedDescription)
                }
            }
        }
    }
}

extension SearchMoviesViewController: MovieTableViewCellDelegate {

    // Favorite Button Tapped
    func favoriteButtonTapped(filmIndex: Int, saved: Bool) {
        selectionFeedback.selectionChanged()
//        films[filmIndex].saved = saved
        FilmPersistence.shared.savedUpdated(film: films[filmIndex], saved: saved)
    }
}
