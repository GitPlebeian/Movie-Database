//
//  UIImageView.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/8/20.
//

import UIKit

extension UIImageView {
    func loadImage(at url: URL) {
        UIImageLoader.shared.load(url, for: self)
    }

    func cancelImageLoad() {
        UIImageLoader.shared.cancel(for: self)
    }
}
