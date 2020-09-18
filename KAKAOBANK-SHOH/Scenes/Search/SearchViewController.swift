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
        
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.value)
            .map { $0 ?? "" }
            .map { Reactor.Action.search(text: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bindSearchBarAnimation(reactor)
        bindCollectionView(reactor)
    }
    
    private func bindSearchBarAnimation(_ reactor: SearchViewReactor) {
        let didBegin = searchBar.rx.textDidBeginEditing
        let didEnd = Observable.merge(
            searchBar.rx.textDidEndEditing.asObservable(),
            searchBar.rx.searchButtonClicked.asObservable(),
            cancelButton.rx.tap.asObservable()
        ).share(replay: 1)
        let isOnByOffset = recentSearchedCV.rx.contentOffset
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
            case let .recentFound(foundKeywords, curSearchKeyword):
                print("recentFound ~~ip : \(ip)")
                let cell = cv.dequeue(FoundCVCell.self, for: ip)
                cell.configure(foundKeywords,
                               curSearchKeyword)
                return cell
            }
        })
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width-20
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
