//
//  BrowseMoviesViewController.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/4/20.
//

import UIKit

class BrowseMoviesViewController: UIViewController {

    // MARK: Properties
    
    var selectionFeedback: UISelectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
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
    }
    
    // Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = filmTableView.indexPathForSelectedRow {
            filmTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // MARK: Actions
    
    // Film Category Changed
    @IBAction func filmCategoryChanged(_ sender: UISegmentedControl) {
        getNewFilms()
    }
    
    // Table View Refreshed
    @objc func tableViewRefreshed() {
        MovieController.shared.emptyBrowseFilms()
        filmTableView.reloadData()
        getNewFilms()
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
        MovieController.shared.cancelBrowseFilmsTask()
        MovieController.shared.getFilmsFromServer(search: search) { (success) in
            DispatchQueue.main.async {
                self.filmTableViewRefreshController.endRefreshing()
                if success {
                    self.filmTableView.reloadData()
                } else {
                    self.presentBasicAlert(title: "Oh-Oh!", message: "Unable to get films from server. Pull down to retry.")
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
        return MovieController.shared.getBrowseFilms().count
    }
    
    // Cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
        
        let film = MovieController.shared.getBrowseFilms()[indexPath.row]
        
        let url = Constants.imageEndpointURL + "w500/" + film.posterPath!
        guard let imgURL = URL(string: url) else {
            return UITableViewCell()
        }
        
        cell.posterImageView.loadImage(at: imgURL)
        cell.configure(indexPath: indexPath,
                       film: film,
                       totalFilmCount: MovieController.shared.getBrowseFilms().count)
        
        return cell
    }
    
    // Did Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let film = MovieController.shared.getBrowseFilms()[indexPath.row]
        guard let cell = tableView.cellForRow(at: indexPath)! as? MovieTableViewCell else {return}
        
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.film = film
        movieDetailViewController.posterImage = cell.posterImageView.image
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}
