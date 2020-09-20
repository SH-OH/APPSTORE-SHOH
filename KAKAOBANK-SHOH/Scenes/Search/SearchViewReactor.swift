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
        var searchedSections: [SearchSection]
        var foundSections: [SearchSection]
        var curSearchBarValue: String
        var showViewType: ShowViewType = .최근검색어화면
    }
    
    let initialState: State
    let navigationController: UINavigationController
    
    let curShowTypeRelay: PublishRelay<ShowViewType> = .init()
    
    init(navigationController: UINavigationController) {
        let testList = [
            "테스트",
            "테스ㅌㅌㅌㅋ",
            "ㅌㅌㅌㅌㅌ",
            "텥ㅌㅌ트틑",
            "테스트트트",
            "테스트 같지만 - 테스트임",
            "테스트2",
            "테스ㅌㅌ2ㅌㅋ",
            "ㅌㅌㅌㅌㅌ2",
            "텥ㅌㅌ트2틑",
            "테스트4트트",
            "테5스트2 같지만 - 테스트임",
            "테스3트2",
            "테스ㅌㅌㅌㅋ",
            "ㅌㅌ54ㅌㅌ2ㅌ",
            "텥ㅌㅌ2트틑",
            "테3스트트트",
            "테스트 6같지만 - 테스트임"
        ]
        let makeItems = testList
            .map { SearchSectionItem.recentSearched($0) }
        let testSection = [SearchSection.recentSearched(makeItems)]
        
        self.initialState = State(
            //            recentSearchedList: UserdefaultsManager.getStringArray(.recentSearchedKeywords)
            searchedSections: testSection,
            foundSections: [],
            curSearchBarValue: ""
        )
        self.navigationController = navigationController
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .findRecent(let responseText):
            let list = [
                "테스트",
                "테스ㅌㅌㅌㅋ",
                "ㅌㅌㅌㅌㅌ",
                "텥ㅌㅌ트틑",
                "테스트트트",
                "테스트 같지만 - 테스트임"
            ]
            //            let list = UserdefaultsManager.getStringArray(.recentSearchedKeywords)
            let find: Observable<Mutation> = Observable.from(list)
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
            return Observable.just(Mutation.setShowViewType(showType))
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
