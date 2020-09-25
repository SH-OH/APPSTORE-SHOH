//
//  SearchViewReactor.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import ReactorKit
import Foundation
import RxCocoa
import UIKit.UINavigationController

final class SearchViewReactor: Reactor {
    
    enum ShowViewType { case 최근검색어화면, 히스토리검색화면, 검색결과화면 }
    
    enum Action {
        case setupSearchedSections([String])
        case findRecent(text: String)
        case didSetCurSearchBarValue(String)
        case show(ShowViewType)
    }
    
    enum Mutation {
        case setSearchedSections([SearchSection])
        case setFoundSections([SearchSection])
        case setCurSearchBarValue(String)
        case setShowViewType(ShowViewType)
    }
    
    
    struct State {
        var searchedSections: [SearchSection]?
        var foundSections: [SearchSection]?
        var curSearchBarValue: String?
        var showViewType: ShowViewType = .최근검색어화면
    }
    
    let initialState: State
    let navigationController: UINavigationController
    
    let recentHistory: BehaviorRelay<[String]>
    let curShowTypeRelay: PublishRelay<ShowViewType> = .init()
    
    init(navigationController: UINavigationController) {
        self.initialState = .init()
        self.navigationController = navigationController
        self.recentHistory = .init(value: UserdefaultsManager.getStringArray(.최신검색어히스토리()))
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .findRecent(let responseText):
            let find: Observable<Mutation> = Observable.from(UserdefaultsManager.getStringArray(.최신검색어히스토리()))
                .filter { $0.contains(responseText) }
                .map { ($0, responseText) }
                .map { SearchSectionItem.recentFound($0) }
                .toArray().asObservable()
                .map { [SearchSection.recentFound($0)] }
                .map { Mutation.setFoundSections($0)}
            
            return find
                .concat(Observable.just(Mutation.setCurSearchBarValue(responseText)))
        case let .didSetCurSearchBarValue(curSearchBarValue):
            return .just(Mutation.setCurSearchBarValue(curSearchBarValue))
        case let .show(showType):
            let setShowViewType: Observable<Mutation> = Observable.just(
                Mutation.setShowViewType(showType)
            )
            return setShowViewType
        case let .setupSearchedSections(history):
            let setSearchedSections: Observable<Mutation> = Observable.from(history)
                .map { SearchSectionItem.recentSearched($0) }
                .toArray().asObservable()
                .map { [SearchSection.recentSearched($0)] }
                .map { Mutation.setSearchedSections($0) }
            return setSearchedSections
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setFoundSections(foundSections):
            newState.foundSections = foundSections
            return newState
        case let .setSearchedSections(searchedSections):
            newState.searchedSections = searchedSections
            return newState
        case let .setCurSearchBarValue(curSearchBarValue):
            newState.curSearchBarValue = curSearchBarValue
            return newState
        case let .setShowViewType(showType):
            newState.showViewType = showType
            return newState
        }
    }
    
}
