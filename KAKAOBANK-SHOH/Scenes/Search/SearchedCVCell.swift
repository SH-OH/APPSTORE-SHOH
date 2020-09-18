//
//  SearchedCVCell.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit.UICollectionViewCell

final class SearchedCVCell: UICollectionViewCell, Reusable {
    
    @IBOutlet private weak var cellLabel: UILabel!
    @IBOutlet private weak var bottomLine: UIView!
    
    func configure(_ recent: String, isLast: Bool) {
        cellLabel.text = recent
        bottomLine.isHidden = isLast
    }
}
