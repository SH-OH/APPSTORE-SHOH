//
//  SearchResultViewController.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/19.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit
import ReactorKit
import RxCocoa

final class SearchResultViewController: BaseViewController, StoryboardView {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    func bind(reactor: SearchResultViewReactor) {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .map { $0.item }
            .withLatestFrom(reactor.state.map { $0.curResultList }, resultSelector: { $1?[safe: $0] })
            .compactMap { $0 }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (result) in
                let vc = StoryboardType.SearchDetail.viewController(SearchDetailViewController.self)
                vc.reactor = SearchDetailViewReactor(result: result,
                                                     searchViewReactor: reactor.searchViewReactor)
                reactor.searchViewReactor.navigationController.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
            
        reactor.state.map { $0.responseText }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .map { SearchResultViewReactor.Action.search(reponseText: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.curResultList }
            .distinctUntilChanged()
            .compactMap { $0 }
            .map { Reactor.Action.createSections($0) }
            .observeOn(MainScheduler.instance)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.resultSections }
            .bind(to: collectionView.rx.items(dataSource: dataSource(reactor.searchViewReactor.navigationController)))
            .disposed(by: disposeBag)
    }
}

// MARK: - DataSource
extension SearchResultViewController: SearchDataSource {
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width
        return CGSize(width: width, height: 270)
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
