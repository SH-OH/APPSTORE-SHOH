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
    
    let curShowTypeRelay: PublishRelay<ShowViewType> = .init()
    
    init() {
        let testList = [
            "녹음기",
            "엠넷",
            "pitu",
            "의지의 히어로",
            "구글맵",
            "진에어",
            "grab",
            "녹음기2",
            "엠넷2",
            "pitu2",
            "의지의 히어로2",
            "구글맵2",
            "진에어2",
            "grab2",
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
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .findRecent(let responseText):
            let list = [
                "카카오뱅크",
                "카카오뱅ㅋ",
                "카카오뱅",
                "카카오뱅쿠",
                "카카오뱅킹",
                "카카오뱅크 - 같지만 다른 은행",
                "카카오뱅킼",
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
