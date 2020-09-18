//
//  SearchViewReactor.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import ReactorKit

final class SearchViewReactor: Reactor {
    
    enum Action {
        case recentFind(text: String)
        case search(text: String)
    }
    
    enum Mutation {
        case setSearchedSections([SearchSection])
        case setFoundSections([SearchSection])
    }
    
    
    struct State {
//        var searchedSectionData: [String]
//        var foundSectionData: [(String, String)]
        
        var searchedSections: [SearchSection]
        var foundSections: [SearchSection]
    }
    
    let initialState: State
    
    init() {
        let testList = [
            "녹음기",
            "엠넷",
            "pitu",
            "의지의 히어로",
            "구글맵",
            "진에어",
            "grab",
            ].map {
            SearchSection.section(items: [.recentSearched("\($0)")])
        }
        
        self.initialState = State(
//            recentSearchedList: UserdefaultsManager.getStringArray(.recentSearchedKeywords)
            searchedSections: testList,
            foundSections: []
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .recentFind(let reponseText):
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
                .filter { $0.contains(reponseText) }
                .map { ($0, reponseText) }
                .map { SearchSectionItem.recentFound($0) }
                .toArray().asObservable()
                .map { [SearchSection.section(items: $0)] }
                .map { Mutation.setFoundSections($0)}
            return find
        case .search(let reponseText):
            let search: Observable<Mutation> = SearchUseCase()
                .search(reponseText)
                .asObservable()
                .map { _ in Mutation.setSearchedSections([])}
            return .empty()
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
        }
    }
    
}
