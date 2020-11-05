//
//  BrowseMoviesViewController.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/4/20.
//

import UIKit

class BrowseMoviesViewController: UIViewController {

    // MARK: Lifecycle
    
    // Did Load
    override func viewDidLoad() {
        super.viewDidLoad()

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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
        
        cell.configure(indexPath: indexPath)
        
        return cell
    }
}
