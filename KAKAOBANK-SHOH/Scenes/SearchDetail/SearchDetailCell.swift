//
//  SearchDetailCell.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/21.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit.UICollectionViewCell
import RxSwift

final class SearchDetailCell: UICollectionViewCell, Reusable {
    
    @IBOutlet private weak var screenShot: IBImageView!
    
    func configure(_ url: URL) {
        _ = NetworkManager.shared.retrieveImage(url)
            .subscribe(onSuccess: { [weak screenShot] (image) in
                screenShot?.image = image
            }, onError: { [weak screenShot] (_) in
                screenShot?.image = nil
            })
    }
}
