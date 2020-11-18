//
//  SearchMoviesViewController.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/4/20.
//

import UIKit

class SearchMoviesViewController: UIViewController {
    
//    // MARK: Properties
//
//    let searchController =     UISearchController(searchResultsController: nil)
//    let selectionFeedback:     UISelectionFeedbackGenerator = UISelectionFeedbackGenerator()
//    var shouldReloadTableView: Bool = true
//
//    // MARK: Views
//
//    @IBOutlet var filmTableView: UITableView!
//
//
//    // MARK: Lifecycle
//
//    // Did Load
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViews()
//    }
//
//    // Will Appear
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        if shouldReloadTableView {
//            filmTableView.reloadData()
//        }
//        if let indexPath = filmTableView.indexPathForSelectedRow {
//            filmTableView.deselectRow(at: indexPath, animated: true)
//        }
//        dismiss(animated: false, completion: nil) // De-focuses the search field
//    }
//
//    // Did Appear
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        shouldReloadTableView = true
//    }
//
//    //MARK: Helpers
//
//    // Present Basic Alert
//    func presentBasicAlert(title: String?, message: String?) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true)
//    }
//
//    // MARK: Setup Views
//
//    func setupViews() {
//        self.view.backgroundColor = .systemBackground
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search Films"
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
//        searchController.searchBar.scopeButtonTitles = ["Movies", "Tv"]
//    }
}

//extension SearchMoviesViewController: UITableViewDelegate, UITableViewDataSource {
//
//    // Num rows in section
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return MovieController.shared.getSearchFilms().count
//    }
//
//    // Cell for row at
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
//
//        let film = MovieController.shared.getSearchFilms()[indexPath.row]
//
//        cell.delegate = self
//        cell.configure(indexPath: indexPath,
//                       film: film,
//                       totalFilmCount: MovieController.shared.getSearchFilms().count,
//                       filmIndex: indexPath.row)
//
//        return cell
//    }
//
//    // Did Select
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let film = MovieController.shared.getSearchFilms()[indexPath.row]
//        guard let cell = tableView.cellForRow(at: indexPath)! as? MovieTableViewCell else {return}
//        let movieDetailViewController = MovieDetailViewController()
//        movieDetailViewController.film = film
//        movieDetailViewController.posterImage = cell.posterImageView.image
//        shouldReloadTableView = false
//        navigationController?.pushViewController(movieDetailViewController, animated: true)
//    }
//}
//
//extension SearchMoviesViewController: UISearchResultsUpdating {
//
//    // Update Search Results
//    func updateSearchResults(for searchController: UISearchController) {
//        let searchBar = searchController.searchBar
//
//        guard let searchText = searchBar.text, searchText != "" else {return}
//
//        var filmSearchType: FilmSearch
//        if searchBar.selectedScopeButtonIndex == 0 {
//            filmSearchType = .movie
//        } else {
//            filmSearchType = .tv
//        }
//
//        MovieController.shared.cancelSearchFilmsTask() // Cancel any existing calls, we do this because people can type fast in the search bar and we don't want 10 pending calls all to be completed at once
//        MovieController.shared.getSearchFilmsFromServer(search: searchText, filmSearchType: filmSearchType) { (success) in
//            DispatchQueue.main.async {
//                if success {
//                    self.filmTableView.reloadData()
//                } else {
//                    self.presentBasicAlert(title: "Oh-Oh!", message: "Unable to get films from server. Please try again later")
//                }
//            }
//        }
//    }
//}
//
//extension SearchMoviesViewController: MovieTableViewCellDelegate {
//
//    // Favorite Button Tapped
//    func favoriteButtonTapped(filmIndex: Int, saved: Bool) {
//        selectionFeedback.selectionChanged()
//        MovieController.shared.searchFilmSaveUpdated(filmIndex: filmIndex, saved: saved)
//    }
//}
