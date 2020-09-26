//
//  NetworkManager+UIImageView.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/19.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit.UIImageView
import RxSwift
import RxCocoa

extension Reactive where Base: UIImageView {
    var setImage: Binder<URL> {
        return Binder(base) { imageView, url in
            self.base.image = nil
            _ = NetworkManager.shared.retrieveImage(url)
                .subscribe(onSuccess: { (image) in
                    self.base.image = image
                }, onError: { (_) in
                    self.base.image = nil
                })
        }
    }
}
