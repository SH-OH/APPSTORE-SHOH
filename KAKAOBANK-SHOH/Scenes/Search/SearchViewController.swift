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
import SnapKit

final class SearchViewController: BaseViewController, StoryboardView {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var separator: UIView!
    @IBOutlet private weak var searchedContentsView: UIView!
    @IBOutlet private weak var recentCV: UICollectionView!
    @IBOutlet private weak var historyCV: UICollectionView!
    
    private let resultViewController = StoryboardType
        .SearchResult
        .viewController(SearchResultViewController.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bind(reactor: SearchViewReactor) {
        let sharedTextChanged: Observable<String> = searchBar.rx.text.changed
            .compactMap { $0 }
            .share(replay: 1)
        
        sharedTextChanged
            .map { Reactor.Action.recentFind(text: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        let searchClicked: Observable<String> = searchBar.rx.searchButtonClicked
            .withLatestFrom(sharedTextChanged)
        
        let collectionViewSelect: Observable<String> = Observable.merge(
            recentCV.rx.zipSelected(SearchSectionItem.self),
            historyCV.rx.zipSelected(SearchSectionItem.self)
        )
            .compactMap({ (ip, item) -> String? in
                switch item {
                case let .recentFound(found):
                    return found.foundKeywords
                case .recentSearched(let searched):
                    return searched
                default:
                    return nil
                }
            })
            .share(replay: 1)
        
        collectionViewSelect
            .bind(to: searchBar.rx.value)
            .disposed(by: disposeBag)
        
        Observable.merge(
            searchClicked.map { _ in },
            collectionViewSelect.map { _ in },
            cancelButton.rx.tap.asObservable()
        )
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak searchBar] (_) in
                searchBar?.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        Observable.merge(
            searchClicked.map { _ in SearchViewReactor.ShowViewType.검색결과화면 },
            collectionViewSelect.map { _ in SearchViewReactor.ShowViewType.검색결과화면 },
            sharedTextChanged
                .map({ $0.isEmpty
                    ? SearchViewReactor.ShowViewType.최근검색어화면
                    : SearchViewReactor.ShowViewType.히스토리검색화면
                })
        )
            .map { Reactor.Action.show($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.showViewType }
            .distinctUntilChanged()
            .observeOn(MainScheduler.asyncInstance)
            .concatMap({ [weak self] (showType) -> Observable<SearchViewReactor.ShowViewType> in
                guard let self = self else { return .empty() }
                switch showType {
                case .최근검색어화면:
                    self.searchedContentsView.isHidden = false
                    self.historyCV.isHidden = true
                    self.dettachResult()
                case .히스토리검색화면:
                    self.searchedContentsView.isHidden = true
                    self.historyCV.isHidden = false
                    self.dettachResult()
                case .검색결과화면:
                    self.searchedContentsView.isHidden = true
                    self.historyCV.isHidden = true
                    self.attachResult(reactor)
                }
                return .just(showType)
            })
            .bind(to: reactor.curShowType)
            .disposed(by: disposeBag)
        
        bindSearchBarAnimation(reactor)
        bindCollectionView(reactor)
    }
    
    private func bindSearchBarAnimation(_ reactor: SearchViewReactor) {
        let didBegin: ControlEvent<Void> = searchBar.rx.textDidBeginEditing
        let didEnd: Observable<Void> = Observable.merge(
            searchBar.rx.searchButtonClicked.asObservable(),
            cancelButton.rx.tap.asObservable()
        ).share(replay: 1)
        
        let isOnByOffset: Observable<Bool> = recentCV.rx.contentOffset
            .map { $0.y }
            .map { $0 > 0 ? true : false }
            .distinctUntilChanged()
        
        let sharedDidAnimationUp = Observable.merge(
            didBegin.map { true },
            didEnd.map { false },
            isOnByOffset
        )
            .distinctUntilChanged()
            .share(replay: 1)
        
        sharedDidAnimationUp
            .withLatestFrom(reactor.state.map { $0.showViewType }, resultSelector: { ($0, $1) })
            .filter { $0.1 == .최근검색어화면 }
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (up, _) in
                guard let self = self else { return }
                let animations: (() -> Void) = { () in
                    self.navigationController?.setNavigationBarHidden(up, animated: false)
                    self.navigationController?.navigationBar.layoutIfNeeded()
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                }
                self.cancelButton.isHidden = !up
                self.separator.isHidden = !up
                UIView.animate(withDuration: 0.3, animations: animations)
            }).disposed(by: disposeBag)
    }
    
    private func bindCollectionView(_ reactor: SearchViewReactor) {
        recentCV.rx.setDelegate(self)
            .disposed(by: disposeBag)
        historyCV.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.searchedSections }
            .distinctUntilChanged()
            .bind(to: recentCV.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.foundSections }
            .distinctUntilChanged()
            .bind(to: historyCV.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
    }
    
}

extension SearchViewController {
    private func attachResult(_ reactor: SearchViewReactor) {
        guard !children.contains(resultViewController) else { return }
        
        resultViewController.reactor = SearchResultViewReactor(searchViewReactor: reactor)
        
        self.addChild(resultViewController)
        self.view.addSubview(resultViewController.view)
        resultViewController.view.snp.makeConstraints { (m) in
            m.edges.equalTo(historyCV)
        }
    }
    private func dettachResult() {
        guard children.contains(resultViewController) else { return }
        
        print("reactor to nil gogogogo !!!!!???")
        resultViewController.reactor = nil
        resultViewController.willMove(toParent: nil)
        resultViewController.view.removeFromSuperview()
        resultViewController.removeFromParent()
        
        print("after dettach")
    }
}

// MARK: - DataSource
extension SearchViewController: SearchDataSource {
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
