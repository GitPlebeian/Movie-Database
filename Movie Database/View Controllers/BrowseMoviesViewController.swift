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
    
    @IBOutlet weak var filmTableView:                UITableView!
    @IBOutlet weak var filmCategorySegmentedControl: UISegmentedControl!
    
    // MARK: Lifecycle
    
    // Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        getNewFilms()
    }
    
    // Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.title = "Browse"
    }
    
    // MARK: Actions
    
    @IBAction func filmCategoryChanged(_ sender: UISegmentedControl) {
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
            fatalError("There are more segments that Browse Searches Enumerations")
        }
        MovieController.shared.getFilms(search: search) { (success) in
            DispatchQueue.main.async {
                if success {
                    self.filmTableView.reloadData()
                } else {

                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: Table View

extension BrowseMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Num rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieController.shared.browseFilms.count
    }
    
    // Cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
        
        cell.delegate = self
        
        let film = MovieController.shared.browseFilms[indexPath.row]
        
        if film.poster == nil {
            MovieController.shared.getMovieImage(index: indexPath.row) {
                DispatchQueue.main.async {
                    self.filmTableView.reloadData()
                }
            }
        }
        
        cell.configure(indexPath: indexPath,
                       film: film,
                       totalFilmCount: MovieController.shared.browseFilms.count)
        
        return cell
    }
    
    // Did Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let film = MovieController.shared.browseFilms[indexPath.row]
        
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.film = film
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

extension BrowseMoviesViewController: MovieTableViewCellDelegate {
    
    // Favorite Toggled
    func favoriteToggled() {
        selectionFeedback.selectionChanged()
    }
}
