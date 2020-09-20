//
//  Reactive+Extensions.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/19.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIImageView {
    var ratingImage: Binder<Double> {
        return Binder(base) { imageView, rating in
            imageView.setRatingImage(CGFloat(rating))
        }
    }
}
