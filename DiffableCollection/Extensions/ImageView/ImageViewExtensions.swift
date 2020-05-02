//
//  ImageViewExtensions.swift
//  DiffableCollection
//
//  Created by Fabrício Masiero on 30/04/20.
//  Copyright © 2020 Fabrício Masiero. All rights reserved.
//

import Foundation
import UIKit

let cache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func setImage(url: URL, onFinish finish: @escaping (_ image: UIImage) -> Void) {
        if let imageCache = cache.object(forKey: url.absoluteString as AnyObject) {
            guard let imageCached = imageCache as? UIImage else {
                return
            }
            finish(imageCached)
        }
        URLSession.shared.dataTask(with: url) { [unowned self] imageData, response, error in
            guard let data = imageData else {
                return
            }
            guard let image = UIImage(data: data) else {
                return
            }
            cache.setObject(image, forKey: url.absoluteString as AnyObject)
            finish(image)
        }.resume()
    }
}
