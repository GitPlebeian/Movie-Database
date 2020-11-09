//
//  UIImageLoader.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/8/20.
//

import UIKit

class UIImageLoader {
    static let shared = UIImageLoader()
    
    private let imageLoader = ImageLoader()
    private var uuidMap = [UIImageView: UUID]()
    
    private init() {}
    
    func load(_ url: URL, for imageView: UIImageView) {
        let taskUUID = imageLoader.loadImage(url) { result in
            defer { self.uuidMap.removeValue(forKey: imageView) }
            do {
                let image = try result.get()
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } catch let error {
                DispatchQueue.main.async {
                    imageView.image = UIImage(named: "No Film Image")
                }
                print("💩💩💩 Error loading image in \(#function) \(error)")
            }
        }
        
        if let taskUUID = taskUUID {
            uuidMap[imageView] = taskUUID
        }
    }
    
    func cancel(for imageView: UIImageView) {
        if let uuid = uuidMap[imageView] {
            imageLoader.cancelLoad(uuid)
            uuidMap.removeValue(forKey: imageView)
        }
    }
}
