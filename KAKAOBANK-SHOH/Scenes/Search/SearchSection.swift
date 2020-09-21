//
//  SearchSection.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import RxDataSources

enum SearchSection {
    case recentSearched([SearchSectionItem])
    case recentFound([SearchSectionItem])
    case result([SearchSectionItem])
}

enum SearchSectionItem {
    case recentSearched(String)
    case recentFound((foundKeywords: String, curSearchKeyword: String))
    case result(SearchResultCellReactor.Data)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .recentFound(found):
            hasher.combine(found.foundKeywords)
            hasher.combine(found.curSearchKeyword)
        case let .recentSearched(searched):
            hasher.combine(searched)
        case let .result(reactorData):
            hasher.combine(reactorData.trackName)
        }
    }
}

extension SearchSection: SectionModelType {
    
    var items: [SearchSectionItem] {
        switch self {
        case .recentFound(let items): return items
        case .recentSearched(let items): return items
        case .result(let items): return items
        }
    }
    
    init(original: SearchSection, items: [SearchSectionItem]) {
        switch original {
        case .recentFound: self = .recentFound(items)
        case .recentSearched: self = .recentSearched(items)
        case .result: self = .result(items)
        }
    }
}

extension SearchSectionItem: Hashable {
    static func == (lhs: SearchSectionItem, rhs: SearchSectionItem) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension SearchSection: Equatable {
}
