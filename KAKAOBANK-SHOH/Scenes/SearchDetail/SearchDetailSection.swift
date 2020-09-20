//
//  SearchDetailSection.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/21.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import RxDataSources
import Foundation

enum SearchDetailSection {
    case screenShots([SearchDetailSectionItem])
    case reviews([SearchDetailSectionItem])
}

enum SearchDetailSectionItem {
    case screenShot(URL)
    case review
}

extension SearchDetailSection: SectionModelType {
    var items: [SearchDetailSectionItem] {
        switch self {
        case .screenShots(let items): return items
        case .reviews(let items): return items
        }
    }
    init(original: SearchDetailSection, items: [SearchDetailSectionItem]) {
        switch original {
        case .screenShots: self = .screenShots(items)
        case .reviews: self = .reviews(items)
        }
    }
}
