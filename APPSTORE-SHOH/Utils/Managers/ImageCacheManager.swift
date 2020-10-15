//
//  ImageCacheManager.swift
//  APPSTORE-SHOH
//
//  Created by Oh Sangho on 2020/09/26.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import Foundation
import UIKit.UIView

final class ImageCacheManager {
    private let ioQueue: DispatchQueue
    
    static let shared = ImageCacheManager()
    
    private let cache: NSCache<NSString, UIImage> = .init()
    
    init() {
        let label: String = "queue.NetworkManager.io.\(UUID().uuidString)"
        self.ioQueue = DispatchQueue(label: label,
                                     qos: .utility)
    }
    
    func getImage(_ key: String, completion: @escaping ((UIImage?) -> Void)) {
        ioQueue.async { [weak cache] in
            let completionWrapper = CompletionWrapper<UIImage?>(completion: completion, defaultValue: nil)
            let getImage: UIImage? = cache?.object(forKey: key as NSString)
            completionWrapper.result(getImage)
        }
    }
    
    func setImage(_ key: String, image: UIImage) {
        ioQueue.async { [weak cache] in
            cache?.setObject(image, forKey: key as NSString)
        }
    }
}
