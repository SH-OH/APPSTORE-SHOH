//
//  SearchViewController.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit.UIViewController
import ReactorKit
import RxCocoa
import RxDataSources
import SnapKit

final class SearchViewController: BaseViewController, StoryboardView {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var separator: UIView!
    @IBOutlet private weak var recentSearchedCV: UICollectionView!
    @IBOutlet private weak var recentFoundCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bind(reactor: SearchViewReactor) {
        searchBar.rx.text
            .map { $0 ?? "" }
            .map { Reactor.Action.recentFind(text: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        let searchClicked: Observable<String> = searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.value)
            .map { $0 ?? "" }
            
        let collectionViewSelect: Observable<String> = Observable.merge(
            recentSearchedCV.rx.modelSelected(SearchSectionItem.self).asObservable(),
            recentFoundCV.rx.modelSelected(SearchSectionItem.self).asObservable()
        )
            .compactMap({ item -> String? in
                switch item {
                case .recentFound((let found, _)):
                    return found
                case .recentSearched(let searched):
                    return searched
                default:
                    return nil
                }
            })
        Observable.merge(
            searchClicked,
            collectionViewSelect
        )
            .map { Reactor.Action.search(text: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        bindSearchBarAnimation(reactor)
        bindCollectionView(reactor)
    }
    
    private func bindSearchBarAnimation(_ reactor: SearchViewReactor) {
        let didBegin: ControlEvent<Void> = searchBar.rx.textDidBeginEditing
        let didEnd: Observable<Void> = Observable.merge(
            searchBar.rx.textDidEndEditing.asObservable(),
            cancelButton.rx.tap.asObservable()
        ).share(replay: 1)
        let isOnByOffset: Observable<Bool> = recentSearchedCV.rx.contentOffset
            .map { $0.y }
            .map { $0 > 0 ? true : false }
            .distinctUntilChanged()
        
        let sharedIsOn = Observable.merge(
            didBegin.map { true },
            didEnd.map { false },
            isOnByOffset
        )
            .distinctUntilChanged()
            .share(replay: 1)
        
        Observable.merge(
            searchBar.rx.value.map { ($0?.isEmpty ?? true) },
            didEnd.map { true }
        )
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak recentFoundCV] (isHidden) in
                recentFoundCV?.isHidden = isHidden
            }).disposed(by: disposeBag)
        
        sharedIsOn
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (isOn) in
                guard let self = self else { return }
                let animations: (() -> Void) = { () in
                    self.navigationController?.setNavigationBarHidden(isOn, animated: false)
                    self.navigationController?.navigationBar.layoutIfNeeded()
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                }
                if !isOn {
                    self.searchBar.resignFirstResponder()
                }
                self.cancelButton.isHidden = !isOn
                self.separator.isHidden = !isOn
                UIView.animate(withDuration: 0.3, animations: animations)
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.showResultView }
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [attachResult] (show) in
                attachResult()
            }).disposed(by: disposeBag)
    }
    
    private func bindCollectionView(_ reactor: SearchViewReactor) {
        recentSearchedCV.rx.setDelegate(self)
            .disposed(by: disposeBag)
        recentFoundCV.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.searchedSections }
            .bind(to: recentSearchedCV.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.foundSections }
            .bind(to: recentFoundCV.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.resultSections }
    }
    
}

extension SearchViewController {
    private func attachResult() {
        let result = StoryboardType
            .SearchResult
            .viewController(SearchResultViewController.self)
        result.reactor = SearchResultViewReactor()
        self.addChild(result)
        result.view.snp.makeConstraints { (m) in
            m.edges.equalTo(recentFoundCV)
        }
    }
}

// MARK: - DataSource
extension SearchViewController {
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<SearchSection> {
        return .init(configureCell: { (ds, cv, ip, item) -> UICollectionViewCell in
            switch item {
            case let .recentSearched(keyword):
                let cell = cv.dequeue(SearchedCVCell.self, for: ip)
                let count = ds.sectionModels.first?.items.count ?? 1
                let isLast = ip.row == count-1
                cell.configure(keyword, isLast: isLast)
                return cell
            case let .recentFound((foundKeywords, curSearchKeyword)):
                let cell = cv.dequeue(FoundCVCell.self, for: ip)
                cell.configure(foundKeywords,
                               curSearchKeyword)
                return cell
            case let .result(reactorData):
                return .init()
            }
        })
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width
        return CGSize(width: width, height: 60.0)
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
