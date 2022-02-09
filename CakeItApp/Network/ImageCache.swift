//
//  ImageCache.swift
//  CakeItApp
//
//  Created by Sarath VS on 2/2/22.
//

import Foundation
import UIKit

public class ImageCache {
    
    public static let publicCache = ImageCache()
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var loadingResponses = [NSURL: [(Cake, UIImage?) -> Swift.Void]]()
    
    public final func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    
    final func loadCakeImages(url: NSURL, item: Cake, completion: @escaping (Cake, UIImage?) -> Swift.Void) {
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(item, cachedImage)
            }
            return
        }
        
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
            return
        } else {
            loadingResponses[url] = [completion]
        }

        print("Download Started with URL \(url)")
        URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            guard let responseData = data, let image = UIImage(data: responseData),
                let blocks = self.loadingResponses[url], error == nil else {
                DispatchQueue.main.async {
                    completion(item, nil)
                }
                return
            }
            guard error == nil else {
                print("Error to download the image URL: \(url)")
                print(error?.localizedDescription ?? "*** Unknown Network error ****")
                return
            }
            
            print("******************** New Image downloaded **************")
            self.cachedImages.setObject(image, forKey: url, cost: responseData.count)
            for block in blocks {
                DispatchQueue.main.async {
                    block(item, image)
                }
                return
            }
        }.resume()
    }
}


// Note: If extending the application: need to make loadCakeImages func generic. 
