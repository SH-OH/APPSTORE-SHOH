//
//  HistoryCVCell.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit.UICollectionViewCell

final class HistoryCVCell: UICollectionViewCell, Reusable {
    
    @IBOutlet private weak var magImage: UIImageView!
    @IBOutlet private weak var cellLabel: UILabel!
    
    func configure(_ foundKeyword: String,
                   _ searchedKeyword: String) {
        cellLabel.setAttributedText(foundKeyword,
                                    attrText: searchedKeyword,
                                    attrs: [.foregroundColor: UIColor.black])
        
        let isHidden = foundKeyword.isEmpty
        magImage.isHidden = isHidden
        cellLabel.isHidden = isHidden
    }
}
