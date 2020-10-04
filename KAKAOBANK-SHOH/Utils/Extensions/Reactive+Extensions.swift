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

extension Reactive where Base: UICollectionView {
    var isHiddenBackgroundView: Binder<Bool> {
        return Binder(base) { collectionView, isHidden in
            guard let backgroundView = collectionView.backgroundView else { return }
            backgroundView.isHidden = isHidden
            let alpha: CGFloat = isHidden ? 0.0 : 1.0
            UIView.animate(withDuration: 0.3) {
                backgroundView.alpha = alpha
                collectionView.layoutIfNeeded()
            }
        }
    }
}
