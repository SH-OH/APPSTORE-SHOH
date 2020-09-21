//
//  ReviewAllHeaderView.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/21.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit
import StoreKit

final class ReviewAllHeaderView: UICollectionReusableView, Reusable {
    
    var item: ReviewAllSectionItem?
    var didTapSort: (() -> ())?
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var userCountLabel: UILabel!
    @IBOutlet weak var writeReviewButton: UIButton!
    @IBOutlet weak var supportAppButton: UIButton!
    @IBOutlet weak var sortReviewButton: UIButton!
    
    func configure(_ item: ReviewAllSectionItem) {
        self.item = item
        ratingLabel.text = "\(item.averRating)"
        userCountLabel.text = "\(item.averRatingCount)개의 평가"
    }
    
    func updateSortButton(_ title: String) {
        sortReviewButton.setTitle(title, for: .normal)
    }
    
    @IBAction private func writeAction(_ sender: Any) {
        guard let url = item?.writeReviewUrl else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url,
                                          options: [:],
                                          completionHandler: nil)
            } else {
                SKStoreReviewController.requestReview()
        }
    }
    @IBAction private func supportAction(_ sender: Any) {
        guard let url = item?.sellerUrl else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url,
                                      options: [:],
                                      completionHandler: nil)
        }
    }
    @IBAction private func sortAction(_ sender: Any) {
        didTapSort?()
    }
}
