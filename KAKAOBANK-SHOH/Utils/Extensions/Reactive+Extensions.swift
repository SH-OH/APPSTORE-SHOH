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

extension Reactive where Base: UICollectionView {
    func zipSelected<T>(_ type: T.Type) -> Observable<(IndexPath, T)> {
        return Observable.zip(
            base.rx.itemSelected,
            base.rx.modelSelected(T.self)
        )
    }
}
