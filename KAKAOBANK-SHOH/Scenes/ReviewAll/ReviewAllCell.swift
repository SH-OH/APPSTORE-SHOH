//
//  ReviewAllCell.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/21.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit.UICollectionViewCell

final class ReviewAllCell: UICollectionViewCell, Reusable {
    
    private var parentViewController: UIViewController?
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var agoLabel: UILabel!
    @IBOutlet private weak var reviewContentsTextView: UITextView!
    @IBOutlet private weak var starImage01: UIImageView!
    @IBOutlet private weak var starImage02: UIImageView!
    @IBOutlet private weak var starImage03: UIImageView!
    @IBOutlet private weak var starImage04: UIImageView!
    @IBOutlet private weak var starImage05: UIImageView!
    
    func configure(_ item: ReviewAllSectionItem) {
        titleLabel.text = item.title
        agoLabel.text = "\(item.updateDate.ago ?? "")"
        reviewContentsTextView.text = item.reviewContents
        if let rating = item.ratingArray[safe: 0] {
            starImage01.setRatingImage(CGFloat(rating))
        }
        if let rating = item.ratingArray[safe: 1] {
            starImage02.setRatingImage(CGFloat(rating))
        }
        if let rating = item.ratingArray[safe: 2] {
            starImage03.setRatingImage(CGFloat(rating))
        }
        if let rating = item.ratingArray[safe: 3] {
            starImage04.setRatingImage(CGFloat(rating))
        }
        if let rating = item.ratingArray[safe: 4] {
            starImage05.setRatingImage(CGFloat(rating))
        }
    }
}
