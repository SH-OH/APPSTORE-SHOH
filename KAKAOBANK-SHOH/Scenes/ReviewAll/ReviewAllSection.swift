//
//  ReviewAllSection.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/21.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import RxDataSources
import Foundation
import UIKit.UINavigationController

enum ReviewAllSection {
    case review([ReviewAllSectionItem])
}

struct ReviewAllSectionItem {
    let averRating: Double
    let averRatingCount: Int
    let writeReviewUrl: URL?
    let sellerUrl: URL?
    let title: String
    let updateDate: Date
    let reviewContents: String
    let rating: Double
    let ratingArray: [Double]
}

extension ReviewAllSection: SectionModelType {
    var items: [ReviewAllSectionItem] {
        switch self {
        case .review(let items): return items
        }
    }
    init(original: ReviewAllSection, items: [ReviewAllSectionItem]) {
        switch original {
        case .review: self = .review(items)
        }
    }
}
