//
//  SearchSection.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import RxDataSources

enum SearchSection {
    case section(items: [SearchSectionItem])
}

enum SearchSectionItem {
    case recentSearched(String)
    case recentFound((foundKeywords: String, curSearchKeyword: String))
}

extension SearchSection: SectionModelType {
    var items: [SearchSectionItem] {
        switch self {
        case .section(let items):
            return items
        }
    }
    
    init(original: SearchSection, items: [SearchSectionItem]) {
        switch original {
        case .section:
            self = .section(items: items)
        }
    }
}
