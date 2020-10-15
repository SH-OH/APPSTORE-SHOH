//
//  ReviewAllViewController.swift
//  APPSTORE-SHOH
//
//  Created by Oh Sangho on 2020/09/21.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit
import ReactorKit
import RxDataSources

final class ReviewAllViewController: BaseViewController, StoryboardView {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    
    func bind(reactor: ReviewAllViewReactor) {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.sortRelay
            .map { Reactor.Action.didSort($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
            
        reactor.state.map { $0.sections }
            .bind(to: collectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
    }
    
}

extension ReviewAllViewController {
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<ReviewAllSection> {
        return .init(configureCell: { (_, cv, ip, item) -> UICollectionViewCell in
            let cell = cv.dequeue(ReviewAllCell.self, for: ip)
            cell.configure(item)
            return cell
        }, configureSupplementaryView: { [presentActionSheet] (ds, cv, kind, ip) -> UICollectionReusableView in
            let headerView = cv.dequeue(ReviewAllHeaderView.self, kind: kind, for: ip)
            if let items = ds.sectionModels.first?.items {
                if let item = items[safe: ip.row] {
                    headerView.configure(item)
                }
            }
            headerView.didTapSort = { [presentActionSheet] () in
                presentActionSheet({ title in
                    if let title = title {
                        headerView.updateSortButton(title)
                    }
                })
            }
            return headerView
        })
    }
    private func presentActionSheet(completion: ((String?) -> ())?) {
        let actionSheet = UIAlertController(title: "정렬", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "가장 도움이 되는 리뷰", style: .default) { [weak reactor] (_) in
            reactor?.sortRelay.accept(.도움)
            completion?("가장 도움이 되는 리뷰")
        }
        let action2 = UIAlertAction(title: "가장 호의적인 리뷰", style: .default) { [weak reactor] (_) in
            reactor?.sortRelay.accept(.호의)
            completion?("가장 호의적인 리뷰")
        }
        let action3 = UIAlertAction(title: "가장 비판적인 리뷰", style: .default) { [weak reactor] (_) in
            reactor?.sortRelay.accept(.비판)
            completion?("가장 비판적인 리뷰")
        }
        let action4 = UIAlertAction(title: "가장 최근 리뷰", style: .default) { [weak reactor] (_) in
            reactor?.sortRelay.accept(.최근)
            completion?("가장 최근 리뷰")
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        actionSheet.addAction(action4)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ReviewAllViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width - 30
        return CGSize(width: width, height: 145)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 15, bottom: 0, right: 15)
    }
}
