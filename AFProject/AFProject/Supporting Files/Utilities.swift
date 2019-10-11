//
//  Utilities.swift
//  AFProject
//
//  Created by Madalina Sinca on 10/10/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

class ImageFetcher
{
    var backup: UIImage? { didSet { callHandlerIfNeeded() } }
    
    func fetch(_ url: URL) {
        loadImage(fromURL: url)
    }
    
    public func loadImage(fromURL imageURL: URL){
        let cache =  URLCache.shared
        let request = URLRequest(url: imageURL.imageURL)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.handler(imageURL, image)
                }
            } else {
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        DispatchQueue.main.async {
                            self.handler(imageURL, image)
                        }
                    } else {
                        self.fetchFailed = true
                    }
                }).resume()
            }
        }
    }
    
    init(handler: @escaping (URL, UIImage) -> Void) {
        self.handler = handler
    }
    
    init(fetch url: URL, handler: @escaping (URL, UIImage) -> Void) {
        self.handler = handler
        fetch(url)
    }
    
    // Private Implementation
    
    private let handler: (URL, UIImage) -> Void
    private var fetchFailed = false { didSet { callHandlerIfNeeded() } }
    private func callHandlerIfNeeded() {
        if fetchFailed, let image = backup, let url = image.storeLocallyAsJPEG(named: String(Date().timeIntervalSinceReferenceDate)) {
            handler(url, image)
        }
    }
}

extension URL {
    var imageURL: URL {
        if let url = UIImage.urlToStoreLocallyAsJPEG(named: self.path) {
            // this was created using UIImage.storeLocallyAsJPEG
            return url
        } else {
            // check to see if there is an embedded imgurl reference
            for query in query?.components(separatedBy: "&") ?? [] {
                let queryComponents = query.components(separatedBy: "=")
                if queryComponents.count == 2 {
                    if queryComponents[0] == "imgurl", let url = URL(string: queryComponents[1].removingPercentEncoding ?? "") {
                        return url
                    }
                }
            }
            return self.baseURL ?? self
        }
    }
}

extension UIImage
{
    private static let localImagesDirectory = "UIImage.storeLocallyAsJPEG"
    
    static func urlToStoreLocallyAsJPEG(named: String) -> URL? {
        var name = named
        let pathComponents = named.components(separatedBy: "/")
        if pathComponents.count > 1 {
            if pathComponents[pathComponents.count-2] == localImagesDirectory {
                name = pathComponents.last!
            } else {
                return nil
            }
        }
        if var url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            url = url.appendingPathComponent(localImagesDirectory)
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
                url = url.appendingPathComponent(name)
                if url.pathExtension != "jpg" {
                    url = url.appendingPathExtension("jpg")
                }
                return url
            } catch let error {
                print("UIImage.urlToStoreLocallyAsJPEG \(error)")
            }
        }
        return nil
    }
    
    func storeLocallyAsJPEG(named name: String) -> URL? {
        if let imageData = self.jpegData(compressionQuality: 1.0) {
            if let url = UIImage.urlToStoreLocallyAsJPEG(named: name) {
                do {
                    try imageData.write(to: url)
                    return url
                } catch let error {
                    print("UIImage.storeLocallyAsJPEG \(error)")
                }
            }
        }
        return nil
    }
    
    func scaled(by factor: CGFloat) -> UIImage? {
        let newSize = CGSize(width: size.width * factor, height: size.height * factor)
        UIGraphicsBeginImageContext(newSize)
        draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    var aspectRatio: Double {
        if let cgImage = self.cgImage {
            return Double(Double(cgImage.width) / Double(cgImage.height))
        }
        return 1
    }
}

extension Sequence {
    func sortAlphabetically<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { a, b in
            return a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
}
