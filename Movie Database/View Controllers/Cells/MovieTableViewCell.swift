//
//  MovieTableViewCell.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/4/20.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    // MARK: Views
    
    weak var innerContentView:                 UIView!
    var      innerContentViewTopConstraint:    NSLayoutConstraint! // Used For Cell Spacing
    var      innerContentViewBottomConstraint: NSLayoutConstraint! // Used For Cell Spacing
    
    // MARK: Styleguide
    
    let interItemSpacing: CGFloat = 16
    
    // MARK: On Creation
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    // MARK: Public Functions
    
    // Configure
    func configure(indexPath: IndexPath) {
        if indexPath.row == 0 {
            innerContentViewTopConstraint.constant = interItemSpacing
            innerContentViewBottomConstraint.constant = interItemSpacing / -2
        } else if indexPath.row == 5 {
            innerContentViewTopConstraint.constant = interItemSpacing / 2
            innerContentViewBottomConstraint.constant = -interItemSpacing
        } else {
            innerContentViewTopConstraint.constant = interItemSpacing / 2
            innerContentViewBottomConstraint.constant = interItemSpacing / -2
        }
    }
    
    // MARK: Other Overrides
    
    override func setSelected(_ selected: Bool, animated: Bool) {}
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
    
    // MARK: Setup Views
    
    private func setupViews() {
        
        // Inner Content View
        let innerContentView = UIView()
        innerContentView.backgroundColor = .blue
        innerContentView.layer.cornerRadius = 8
        innerContentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(innerContentView)
        innerContentViewTopConstraint = innerContentView.topAnchor.constraint(equalTo: contentView.topAnchor)
        innerContentViewBottomConstraint = innerContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        NSLayoutConstraint.activate([
            innerContentViewTopConstraint,
            innerContentViewBottomConstraint,
            innerContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            innerContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            innerContentView.heightAnchor.constraint(equalToConstant: 60)
        ])
        self.innerContentView = innerContentView
    }
}
