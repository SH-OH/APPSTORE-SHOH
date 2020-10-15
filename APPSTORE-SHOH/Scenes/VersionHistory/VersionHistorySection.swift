//
//  VersionHistorySection.swift
//  APPSTORE-SHOH
//
//  Created by Oh Sangho on 2020/09/21.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import RxDataSources

enum VersionHistorySection {
    case version([VersionHistorySectionItem])
}

struct VersionHistorySectionItem {
    let version: String
    let ago: String
    let notes: String
}

extension VersionHistorySection: SectionModelType {
    var items: [VersionHistorySectionItem] {
        switch self {
        case .version(let items): return items
        }
    }
    init(original: VersionHistorySection, items: [VersionHistorySectionItem]) {
        switch original {
        case .version: self = .version(items)
        }
    }
}
