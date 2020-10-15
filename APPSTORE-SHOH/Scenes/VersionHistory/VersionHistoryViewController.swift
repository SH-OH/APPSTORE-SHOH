//
//  VersionHistoryViewController.swift
//  APPSTORE-SHOH
//
//  Created by Oh Sangho on 2020/09/21.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit
import ReactorKit
import RxDataSources

final class VersionHistoryViewController: BaseViewController, StoryboardView {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    func bind(reactor: VersionHistoryViewReactor) {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.sections }
            .bind(to: collectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
    }
}

extension VersionHistoryViewController {
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<VersionHistorySection> {
        return .init(configureCell: { (_, cv, ip, item) -> UICollectionViewCell in
            let cell = cv.dequeue(VersionHistoryCell.self, for: ip)
            cell.configure(item)
            return cell
        }, configureSupplementaryView: { (_, cv, kind, ip) -> UICollectionReusableView in
            let header = cv.dequeueReusableSupplementaryView(ofKind: kind,
                                                             withReuseIdentifier: "VersionHistoryHeader",
                                                             for: ip)
            return header
        })
    }
}

extension VersionHistoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width
        return CGSize(width: width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
