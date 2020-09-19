//
//  SearchDataSouces.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/19.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import RxDataSources
import UIKit.UICollectionViewCell

protocol SearchDataSource: class {}

extension SearchDataSource {
    func dataSource() -> RxCollectionViewSectionedReloadDataSource<SearchSection> {
        return .init(configureCell: { (ds, cv, ip, item) -> UICollectionViewCell in
            switch item {
            case let .recentSearched(keyword):
                let cell = cv.dequeue(RecentCVCell.self, for: ip)
                let count = ds.sectionModels.first?.items.count ?? 1
                let isLast = ip.row == count-1
                cell.configure(keyword, isLast: isLast)
                return cell
            case let .recentFound((foundKeywords, curSearchKeyword)):
                let cell = cv.dequeue(HistoryCVCell.self, for: ip)
                cell.configure(foundKeywords,
                               curSearchKeyword)
                return cell
            case let .result(reactorData):
                let cell = cv.dequeue(SearchResultCell.self, for: ip)
                cell.reactor = SearchResultCellReactor(data: reactorData)
                return cell
            }
        }, configureSupplementaryView: { (ds, cv, kind, ip) -> UICollectionReusableView in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RecentHeader", for: ip)
                return headerView
            default:
                assert(false)
            }
        })
    }
}
