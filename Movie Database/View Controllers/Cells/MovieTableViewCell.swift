//
//  MovieTableViewCell.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/4/20.
//

import UIKit

protocol MovieTableViewCellDelegate: class {
    func favoriteToggled()
}

class MovieTableViewCell: UITableViewCell {

    // MARK: Properties
    
    weak var delegate: MovieTableViewCellDelegate?
    
    // MARK: Views
    
    weak var innerContentView:                 UIView!
    var      innerContentViewTopConstraint:    NSLayoutConstraint! // Used For Cell Spacing
    var      innerContentViewBottomConstraint: NSLayoutConstraint! // Used For Cell Spacing
    weak var primaryStackView:                 UIStackView!
    weak var posterView:                       UIView!
    weak var posterImageView:                  UIImageView!
    weak var textInformationStackView:         UIStackView!
    weak var titleLabel:                       UILabel!
    weak var favoriteButton:                   UIButton!
    weak var favoriteButtonImageView:          UIImageView!
    weak var rowOneStackView:                  UIStackView!
    weak var rowTwoStackView:                  UIStackView!
    
    // MARK: Styleguide
    
    let interItemSpacing: CGFloat = 16
    let padding:          CGFloat = 8
    
    // MARK: On Creation
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    // MARK: Public Functions
    
    // Configure
    func configure(indexPath: IndexPath, film: Film, totalFilmCount: Int) {
        // Update cell spacing
        if indexPath.row == 0 {
            innerContentViewTopConstraint.constant = interItemSpacing
            innerContentViewBottomConstraint.constant = interItemSpacing / -2
        } else if indexPath.row == totalFilmCount - 1 {
            innerContentViewTopConstraint.constant = interItemSpacing / 2
            innerContentViewBottomConstraint.constant = -interItemSpacing
        } else {
            innerContentViewTopConstraint.constant = interItemSpacing / 2
            innerContentViewBottomConstraint.constant = interItemSpacing / -2
        }
        // Update Data
        titleLabel.text = film.name
        if let image = film.poster {
            // Display Image
            posterImageView.image = image
        } else {
            // Get Image From Server
            posterImageView.image = nil
        }
    }
    
    // MARK: Other Overrides
    
    override func setSelected(_ selected: Bool, animated: Bool) {}
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
    
    // MARK: Actions
    
    // Favorite Button Tapped
    @objc private func favoriteButtonTapped() {
        delegate?.favoriteToggled()
    }
    
    // MARK: Setup Views
    
    private func setupViews() {
        // Inner Content View
        let innerContentView = UIView()
        innerContentView.backgroundColor = .systemGray5
        innerContentView.layer.cornerRadius = 8
        innerContentView.layer.shadowColor = UIColor.systemGray4.cgColor
        innerContentView.layer.shadowOpacity = 1
        innerContentView.layer.shadowOffset = CGSize(width: 1, height: 2)
        innerContentView.layer.shadowRadius = 1.5
        innerContentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(innerContentView)
        innerContentViewTopConstraint = innerContentView.topAnchor.constraint(equalTo: contentView.topAnchor)
        innerContentViewBottomConstraint = innerContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        // Set contraint priority to high to avoid breaking constraint errors
        innerContentViewTopConstraint.priority = .defaultHigh
        innerContentViewBottomConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            innerContentViewTopConstraint,
            innerContentViewBottomConstraint,
            innerContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            innerContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            innerContentView.heightAnchor.constraint(equalToConstant: 140)
        ])
        self.innerContentView = innerContentView
        
        // Primary Stack View
        let primaryStackView = UIStackView()
        primaryStackView.axis = .horizontal
        primaryStackView.spacing = 16
        primaryStackView.translatesAutoresizingMaskIntoConstraints = false
        innerContentView.addSubview(primaryStackView)
        NSLayoutConstraint.activate([
            primaryStackView.topAnchor.constraint(equalTo: innerContentView.topAnchor, constant: padding),
            primaryStackView.leadingAnchor.constraint(equalTo: innerContentView.leadingAnchor, constant: padding),
            primaryStackView.trailingAnchor.constraint(equalTo: innerContentView.trailingAnchor, constant: -padding),
            primaryStackView.bottomAnchor.constraint(equalTo: innerContentView.bottomAnchor, constant: -padding)
        ])
        self.primaryStackView = primaryStackView
        
        // Poster View
        let posterView = UIView()
        posterView.layer.cornerRadius = 8
        posterView.layer.masksToBounds = true
        posterView.backgroundColor = UIColor.systemGray3
        posterView.translatesAutoresizingMaskIntoConstraints = false
        primaryStackView.addArrangedSubview(posterView)
        NSLayoutConstraint.activate([
            posterView.topAnchor.constraint(equalTo: primaryStackView.topAnchor),
            posterView.bottomAnchor.constraint(equalTo: primaryStackView.bottomAnchor),
            posterView.widthAnchor.constraint(equalTo: posterView.heightAnchor, multiplier: 0.7142) // Poster Ratio == 0.7142
        ])
        self.posterView = posterView
        
        // Poster Image View
        let posterImageView = UIImageView()
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterView.addSubview(posterImageView)
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: posterView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: posterView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: posterView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: posterView.bottomAnchor)
        ])
        self.posterImageView = posterImageView
        
        // Text Information Stack View
        let textInformationStackView = UIStackView()
        textInformationStackView.axis = .vertical
        textInformationStackView.translatesAutoresizingMaskIntoConstraints = false
        primaryStackView.addArrangedSubview(textInformationStackView)
        NSLayoutConstraint.activate([
            textInformationStackView.topAnchor.constraint(equalTo: primaryStackView.topAnchor),
            textInformationStackView.bottomAnchor.constraint(equalTo: primaryStackView.bottomAnchor)
        ])
        self.textInformationStackView = textInformationStackView

        // Row One Stack View
        let rowOneStackView = UIStackView()
        rowOneStackView.axis = .horizontal
        rowOneStackView.alignment = .top
        rowOneStackView.spacing = 8
        rowOneStackView.translatesAutoresizingMaskIntoConstraints = false
        textInformationStackView.addArrangedSubview(rowOneStackView)
        NSLayoutConstraint.activate([

        ])
        self.rowOneStackView = rowOneStackView
        
        // Row Two Stack View
        let rowTwoStackView = UIStackView()
        rowTwoStackView.axis = .horizontal
        rowTwoStackView.translatesAutoresizingMaskIntoConstraints = false
        textInformationStackView.addArrangedSubview(rowTwoStackView)
        NSLayoutConstraint.activate([

        ])
        self.rowTwoStackView = rowTwoStackView
        
        // Title Label
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: Text.robotoBlack, size: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        rowOneStackView.addArrangedSubview(titleLabel)
        NSLayoutConstraint.activate([
            
        ])
        self.titleLabel = titleLabel
        
        // Favorite Button
        let favoriteButton = UIButton()
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        favoriteButton.tintColor = .systemYellow
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        rowOneStackView.addArrangedSubview(favoriteButton)
        NSLayoutConstraint.activate([
            favoriteButton.widthAnchor.constraint(equalToConstant: 36),
            favoriteButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        self.favoriteButton = favoriteButton
        
        // Favorite Button Image View
        let favoriteButtonImageView = UIImageView(image: UIImage(systemName: "star"))
        favoriteButtonImageView.contentMode = .scaleAspectFit
        favoriteButtonImageView.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addSubview(favoriteButtonImageView)
        NSLayoutConstraint.activate([
            favoriteButtonImageView.topAnchor.constraint(equalTo: favoriteButton.topAnchor),
            favoriteButtonImageView.leadingAnchor.constraint(equalTo: favoriteButton.leadingAnchor),
            favoriteButtonImageView.trailingAnchor.constraint(equalTo: favoriteButton.trailingAnchor),
            favoriteButtonImageView.bottomAnchor.constraint(equalTo: favoriteButton.bottomAnchor)
        ])
        self.favoriteButtonImageView = favoriteButtonImageView
    }
}
