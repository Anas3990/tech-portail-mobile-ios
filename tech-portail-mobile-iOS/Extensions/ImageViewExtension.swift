//
//  ImageViewExtension.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-12-27.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

//
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String) {
        self.image = nil
        
        //
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if let error = error {
                print(error)
                return
            } else {
                if let data = data {
                    DispatchQueue.main.async {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                            
                            self.image = downloadedImage
                        }
                    }
                } else {
                    
                }
            }
        }).resume()
    }
}
