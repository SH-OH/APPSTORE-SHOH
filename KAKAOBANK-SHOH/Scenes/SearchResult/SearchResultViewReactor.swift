//
//  SearchResultViewReactor.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/19.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import ReactorKit
import Foundation
import RxCocoa

final class SearchResultViewReactor: Reactor {
    enum Action {
        case search(reponseText: String)
        case createSections([SearchResult])
        case clear
    }
    
    enum Mutation {
        case setResponseText(String)
        case setSearchedText(String)
        case setCurResultList([SearchResult])
        case setResultSections([SearchSection])
    }
    
    struct State {
        var responseText: String = ""
        var searchedText: String = ""
        var curResultList: [SearchResult]?
        var resultSections: [SearchSection] = []
    }
    
    let initialState: State
    let searchViewReactor: SearchViewReactor
    
    init(searchViewReactor: SearchViewReactor) {
        self.initialState = .init()
        self.searchViewReactor = searchViewReactor
    }
    
    deinit {
        print("[👋deinit]\(String(describing: self))")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .search(let responseText):
            let search: Observable<Mutation> = Observable.just(responseText)
                .flatMap { SearchUseCase().search($0) }
                .compactMap { $0.results }
                .asObservable()
                .map { Mutation.setCurResultList($0) }
            
            return search
        case .createSections(let resultList):
            let setSections: Observable<Mutation> = Observable.from(resultList)
                .compactMap { [weak self] in self?.convertModel($0)}
                .map { SearchSectionItem.result($0) }
                .toArray().asObservable()
                .map { [SearchSection.result($0)] }
                .map { Mutation.setResultSections($0) }
            
            return setSections
        case .clear:
            return .just(Mutation.setCurResultList([]))
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let setResponseText: Observable<Mutation> = searchViewReactor.curShowTypeRelay
            .filter { $0 == .검색결과화면 }
            .withLatestFrom(searchViewReactor.state.map { $0.curSearchBarValue })
            .compactMap { $0 }
            .distinctUntilChanged()
            .map { Mutation.setResponseText($0)}
        
        let updateHistory: Observable<Mutation> = mutation
            .flatMap ({ [weak searchViewReactor] (mutation) -> Observable<Mutation> in
                if case .setCurResultList = mutation {
                    let updateList = UserdefaultsManager.getStringArray(.최신검색어히스토리())
                    searchViewReactor?.recentHistory.accept(updateList)
                }
                return .just(mutation)
            })
        
        return Observable.merge(setResponseText,
                                updateHistory)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setResponseText(let responseText):
            newState.responseText = responseText
            return newState
        case .setCurResultList(let resultList):
            newState.curResultList = resultList
            return newState
        case .setResultSections(let resultSections):
            newState.resultSections = resultSections
            return newState
        case .setSearchedText(let searchedText):
            newState.searchedText = searchedText
            return newState
        }
    }
}

extension SearchResultViewReactor {
    private func convertModel(_ result: SearchResult) -> SearchResultCellReactor.Data {
        let userCount = result.userRatingCountForCurrentVersion ?? 0
        
        let screenshotUrls = result.screenshotUrls?
            .compactMap { URL(string: $0) }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        let averageUserRatingForCurrentVersion = numberFormatter
            .string(from: (result.averageUserRatingForCurrentVersion ?? 0) as NSNumber) ?? "0"
        let ratingToDouble = Double(averageUserRatingForCurrentVersion) ?? 0
        
        var ratingArray: [Double] = []
        for index in 0..<5 {
            var rating = ratingToDouble-Double(index)
            rating = rating <= 0 ? 0 : rating
            rating = rating >= 1 ? 1 : rating
            ratingArray.append(rating)
        }
        
        return SearchResultCellReactor.Data(
            artworkUrl60: URL(string: (result.artworkUrl60 ?? "")),
            trackName: result.trackCensoredName,
            description: result.description,
            ratingArray: ratingArray,
            userRatingCount: userCount.userCountToSpell,
            screenshotUrls: screenshotUrls
        )
    }
}
