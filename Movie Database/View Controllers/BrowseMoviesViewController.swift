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
    
    @IBOutlet weak var filmTableView: UITableView!
    
    // MARK: Lifecycle
    
    // Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        MovieController.shared.getMoviesTest { (success) in
            DispatchQueue.main.async {
                if success {
                    self.filmTableView.reloadData()
                } else {
                    
                }
            }
        }
    }
    
    // Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.title = "Browse"
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
            // Get Poster Image
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
}

extension BrowseMoviesViewController: MovieTableViewCellDelegate {
    
    // Favorite Toggled
    func favoriteToggled() {
        selectionFeedback.selectionChanged()
    }
}
