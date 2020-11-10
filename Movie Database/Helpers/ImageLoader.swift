//
//  ImageLoader.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/8/20.
//

import UIKit

enum ImageLoadingError: Error {
    case dataConvert
}

extension ImageLoadingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dataConvert:
            return NSLocalizedString("Description of data convert error", comment: "Unable to convert data to image.")
        }
    }
}

class ImageLoader {
    
    static let shared = ImageLoader()
    
    private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    // Load Image
    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        
        // Don't download image if we already have it
        if let image = loadedImages[url] {
            completion(.success(image))
            return nil
        }
        
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Remove this task from running requests
            defer {self.runningRequests.removeValue(forKey: uuid)}
            
            if let error = error {
                if (error as NSError).code != NSURLErrorCancelled {
                    completion(.failure(error))
                } // No else becuase that means that the call was cancelled
                return
            }
            
            guard let data = data else {
                completion(.failure(URLSessionError.dataNotProvided))
                return
            }
            
            if let image = UIImage(data: data) {
                self.loadedImages[url] = image
                completion(.success(image))
                return
            }
            completion(.failure(ImageLoadingError.dataConvert))
            return
        }
        task.resume()
        
        // Add the current task to running requests so we can maybe cancel it later
        runningRequests[uuid] = task
        return uuid
    }
    
    // Cancel Load
    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}


