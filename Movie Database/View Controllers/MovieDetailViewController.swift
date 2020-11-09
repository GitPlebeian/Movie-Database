//
//  MovieDetailViewController.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/4/20.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var film:                  Film!
    var posterImage:           UIImage?
    var shouldAnimateBackdrop: Bool = true
    
    // MARK: Views
    
    weak var scrollView:                             UIScrollView!
    weak var informationView:                        UIView!
    var      informationViewTopLayoutConstraint:     NSLayoutConstraint! // Will change if no backdrop image was found
    weak var textInfoView:                           UIView!
    weak var movieTitleLabel:                        UILabel!
    weak var movieReleaseDateLabel:                  UILabel!
    weak var movieReleaseDate:                       UILabel!
    weak var movieContentView:                       UIView!
    weak var overviewLabel:                          UILabel!
    weak var overviewContentLabel:                   UILabel!
    weak var backdropView:                           UIView!
    weak var backdropImageView:                      UIImageView!
    var      backdropImageViewTopConstraintStretchy: NSLayoutConstraint! // Used for paralax backdrop scrolling
    var      backdropImageViewTopConstraintNormal:   NSLayoutConstraint! // Used for paralax backdrop scrolling
    weak var backdropActivityIndicator:              UIActivityIndicatorView!
    weak var posterImageView:                        UIImageView!
    var      posterImageViewVerticalConstraint:      NSLayoutConstraint! // Will change if no backdrop image was found
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        handleBackdropImage()
    }
    
    // MARK: Helpers
    
    // Start Backdrop Image Request
    func startBackdropImageRequest(_ completion: @escaping (UIImage?) -> Void) {
        guard let backdropPath = film.backdropPath else {
            completion(nil)
            return
        }
        
        let url = "https://image.tmdb.org/t/p/original/" + backdropPath
        
        guard let imgURL = URL(string: url) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: imgURL) { data, response, error in
            
            if let error = error {
                print("💩💩💩 Error in \(#function) \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                completion(image)
                return
            }
            completion(nil)
        }.resume()
    }
    
    // Handle Backdrop Image
    func handleBackdropImage() {
        startBackdropImageRequest { (backdropImage) in
            DispatchQueue.main.async {
                self.backdropActivityIndicator.stopAnimating()
                if let backdropImage = backdropImage {
                    self.backdropImageView.image = backdropImage
                } else {
                    // Updates constraints so that the valid content is moved up to fill the space of the empty backdrop image view
                    self.shouldAnimateBackdrop = false
                    self.informationViewTopLayoutConstraint.isActive = false
                    self.informationViewTopLayoutConstraint = self.informationView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 16)
                    self.informationViewTopLayoutConstraint.isActive = true
                    self.posterImageViewVerticalConstraint.isActive = false
                    self.posterImageViewVerticalConstraint = self.posterImageView.topAnchor.constraint(equalTo: self.informationView.topAnchor)
                    self.posterImageViewVerticalConstraint.isActive = true
                }
            }
        }
    }
    
    // MARK: Setup Views
    
    func setupViews() {
        
        view.backgroundColor = .systemBackground
        title = film.title ?? film.name
        
        // Scroll views
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        self.scrollView = scrollView
        
        // Information View
        let informationView = UIView()
        informationView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(informationView)
        informationViewTopLayoutConstraint = informationView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: UIScreen.main.bounds.width * 0.562)
        NSLayoutConstraint.activate([
            informationViewTopLayoutConstraint,
            informationView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            informationView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            informationView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            informationView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        self.informationView = informationView
        
        // Backdrop View
        let backdropView = UIView()
        backdropView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(backdropView)
        NSLayoutConstraint.activate([
            backdropView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            backdropView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            backdropView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            backdropView.bottomAnchor.constraint(equalTo: informationView.topAnchor)
        ])
        self.backdropView = backdropView
        
        // Backdrop Image View
        let backdropImageView = UIImageView()
        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.translatesAutoresizingMaskIntoConstraints = false
        backdropView.addSubview(backdropImageView)
        backdropImageViewTopConstraintStretchy = backdropImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        backdropImageViewTopConstraintNormal = backdropImageView.topAnchor.constraint(equalTo: backdropView.topAnchor)
        NSLayoutConstraint.activate([
            backdropImageViewTopConstraintStretchy,
            backdropImageView.leadingAnchor.constraint(equalTo: backdropView.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: backdropView.trailingAnchor),
            backdropImageView.bottomAnchor.constraint(equalTo: backdropView.bottomAnchor)
        ])
        self.backdropImageView = backdropImageView
        
        // Backdrop Activity Indicator
        let backdropActivityIndicator = UIActivityIndicatorView()
        backdropActivityIndicator.startAnimating()
        backdropActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        backdropImageView.addSubview(backdropActivityIndicator)
        NSLayoutConstraint.activate([
            backdropActivityIndicator.centerYAnchor.constraint(equalTo: backdropImageView.centerYAnchor),
            backdropActivityIndicator.centerXAnchor.constraint(equalTo: backdropImageView.centerXAnchor)
        ])
        self.backdropActivityIndicator = backdropActivityIndicator
        
        // Poster Image View
        let posterImageView = UIImageView()
        posterImageView.image = posterImage ?? UIImage(named: "No Film Image")
        posterImageView.layer.borderColor = UIColor.white.cgColor
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.borderWidth = 2
        posterImageView.layer.cornerRadius = 8
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        informationView.addSubview(posterImageView)
        posterImageViewVerticalConstraint = posterImageView.centerYAnchor.constraint(equalTo: informationView.topAnchor, constant: 32)
        NSLayoutConstraint.activate([
            posterImageViewVerticalConstraint,
            posterImageView.leadingAnchor.constraint(equalTo: informationView.leadingAnchor, constant: 16),
            posterImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.562 * 0.75),
            posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor, multiplier: 0.666)
        ])
        self.posterImageView = posterImageView
        
        scrollView.bringSubviewToFront(informationView)
        
        // Text Info View
        let textInfoView = UIView()
        textInfoView.backgroundColor = .systemBackground
        textInfoView.layer.cornerRadius = 8
        textInfoView.translatesAutoresizingMaskIntoConstraints = false
        informationView.addSubview(textInfoView)
        NSLayoutConstraint.activate([
            textInfoView.topAnchor.constraint(equalTo: informationView.topAnchor, constant: 16),
            textInfoView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 8),
            textInfoView.trailingAnchor.constraint(equalTo: informationView.trailingAnchor, constant: -16),
            textInfoView.bottomAnchor.constraint(greaterThanOrEqualTo: posterImageView.bottomAnchor)
        ])
        self.textInfoView = textInfoView
        
        // Movie Title Label
        let movieTitleLabel = UILabel()
        movieTitleLabel.text = film.name ?? film.title
        movieTitleLabel.font = UIFont(name: Text.robotoBlack, size: 16)
        movieTitleLabel.numberOfLines = 0
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        textInfoView.addSubview(movieTitleLabel)
        NSLayoutConstraint.activate([
            movieTitleLabel.topAnchor.constraint(equalTo: textInfoView.topAnchor, constant: 16),
            movieTitleLabel.leadingAnchor.constraint(equalTo: textInfoView.leadingAnchor, constant: 16),
            movieTitleLabel.trailingAnchor.constraint(equalTo: textInfoView.trailingAnchor, constant: -16)
        ])
        self.movieTitleLabel = movieTitleLabel
        
        
        // Movie Release Date Label
        let movieReleaseDateLabel = UILabel()
        movieReleaseDateLabel.text = film.releaseDate != nil ? "Released" : film.firstAirDate != nil ? "First Aired" : ""
        movieReleaseDateLabel.font = UIFont(name: Text.robotoBold, size: 12)
        movieReleaseDateLabel.textColor = .systemGray
        movieReleaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        textInfoView.addSubview(movieReleaseDateLabel)
        NSLayoutConstraint.activate([
            movieReleaseDateLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 8),
            movieReleaseDateLabel.leadingAnchor.constraint(equalTo: movieTitleLabel.leadingAnchor),
            movieReleaseDateLabel.trailingAnchor.constraint(equalTo: movieTitleLabel.trailingAnchor)
        ])
        self.movieReleaseDateLabel = movieReleaseDateLabel
        
        // Movie Release Date
        let movieReleaseDate = UILabel()
        movieReleaseDate.text = film.releaseDate
        movieReleaseDate.font = UIFont(name: Text.robotoMedium, size: 14)
        movieReleaseDate.numberOfLines = 0
        movieReleaseDate.translatesAutoresizingMaskIntoConstraints = false
        textInfoView.addSubview(movieReleaseDate)
        NSLayoutConstraint.activate([
            movieReleaseDate.topAnchor.constraint(equalTo: movieReleaseDateLabel.bottomAnchor, constant: 4),
            movieReleaseDate.leadingAnchor.constraint(equalTo: movieTitleLabel.leadingAnchor),
            movieReleaseDate.trailingAnchor.constraint(equalTo: movieTitleLabel.trailingAnchor),
            movieReleaseDate.bottomAnchor.constraint(lessThanOrEqualTo: textInfoView.bottomAnchor, constant: -16)
        ])
        self.movieReleaseDate = movieReleaseDate
        // Set the label with correct format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let airDate = dateFormatter.date(from: (film.releaseDate ?? film.firstAirDate ?? "")) {
            dateFormatter.dateFormat = "M/d/yyyy"
            movieReleaseDate.text = dateFormatter.string(from: airDate)
        }
        
        // Movie Content View
        let movieContentView = UIView()
        movieContentView.backgroundColor = .systemGray6
        movieContentView.layer.cornerRadius = 16
        movieContentView.translatesAutoresizingMaskIntoConstraints = false
        informationView.addSubview(movieContentView)
        NSLayoutConstraint.activate([
            movieContentView.topAnchor.constraint(equalTo: textInfoView.bottomAnchor, constant: 16),
            movieContentView.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            movieContentView.trailingAnchor.constraint(equalTo: textInfoView.trailingAnchor),
            movieContentView.bottomAnchor.constraint(equalTo: informationView.bottomAnchor, constant: -16)
        ])
        self.movieContentView = movieContentView
        
        // Overview Label
        let overviewLabel = UILabel()
        overviewLabel.text = "Overview"
        overviewLabel.font = UIFont(name: Text.robotoBlack, size: 22)
        overviewLabel.textColor = .systemGray
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        movieContentView.addSubview(overviewLabel)
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: movieContentView.topAnchor, constant: 16),
            overviewLabel.leadingAnchor.constraint(equalTo: movieContentView.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: movieContentView.trailingAnchor, constant: -16)
        ])
        self.overviewLabel = overviewLabel
        
        // Overview Content Label
        let overviewContentLabel = UILabel()
        overviewContentLabel.numberOfLines = 0
        overviewContentLabel.font = UIFont(name: Text.robotoMedium, size: 14)
        overviewContentLabel.text = film.overview
        overviewContentLabel.translatesAutoresizingMaskIntoConstraints = false
        movieContentView.addSubview(overviewContentLabel)
        NSLayoutConstraint.activate([
            overviewContentLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 16),
            overviewContentLabel.leadingAnchor.constraint(equalTo: movieContentView.leadingAnchor, constant: 16),
            overviewContentLabel.trailingAnchor.constraint(equalTo: movieContentView.trailingAnchor, constant: -16),
            overviewContentLabel.bottomAnchor.constraint(equalTo: movieContentView.bottomAnchor, constant: -16)
        ])
        self.overviewContentLabel = overviewContentLabel
    }
}

extension MovieDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Used for the paralax effect when scrolling up or down
        if shouldAnimateBackdrop {
            if scrollView.contentOffset.y < 0 {
                backdropImageViewTopConstraintNormal.isActive = false
                backdropImageViewTopConstraintStretchy.isActive = true
                backdropView.transform = .identity
            } else {
                backdropImageViewTopConstraintStretchy.isActive = false
                backdropImageViewTopConstraintNormal.isActive = true
                backdropView.transform = CGAffineTransform(translationX: 0, y: scrollView.contentOffset.y / 3)
            }
        }
    }
}
