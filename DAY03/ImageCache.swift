//
//  ImageCache.swift
//  DAY03
//
//  Created by Zuleykha Pavlichenkova on 12.08.2022.
//

import UIKit

final class DefaultImageCache {
    
    static let shared = DefaultImageCache()
    var storage: [String: UIImage] = [:]
    let accessQ = DispatchQueue(
        label: "com.some...",
        attributes: .concurrent
    )
    
    func setImage(_ image: UIImage?, key: String) {
        accessQ.async(flags: .barrier) {
            self.storage[key] = image
        }
    }

    func getImage(forKey key: String) -> UIImage? {
        accessQ.sync {
            return storage[key]
        }
    }
}
//
//protocol ImageCache {
//    func setImage(_ image: UIImage?, key: String)
//    func getImage(forKey key: String) -> UIImage?
//}
