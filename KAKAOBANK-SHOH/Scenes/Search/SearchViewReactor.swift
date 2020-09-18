//
//  SearchViewReactor.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import ReactorKit
import Foundation

final class SearchViewReactor: Reactor {
    
    enum Action {
        case recentFind(text: String)
        case search(text: String)
    }
    
    enum Mutation {
        case setSearchedSections([SearchSection])
        case setFoundSections([SearchSection])
        case setResultSections([SearchSection])
        case setShowResultView(Bool)
    }
    
    
    struct State {
//        var searchedSectionData: [String]
//        var foundSectionData: [(String, String)]
        
        var searchedSections: [SearchSection]
        var foundSections: [SearchSection]
        var resultSections: [SearchSection]
        var showResultView: Bool
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
            foundSections: [],
            resultSections: [],
            showResultView: false
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
                .do(onSuccess: { (_) in
                    var list = UserdefaultsManager.getStringArray(.recentSearchedKeywords)
                    if !list.contains(reponseText) {
                        list.append(reponseText)
                    }
                })
                .compactMap { $0.results }
                .asObservable()
                .map { [convertModel] in convertModel($0) }
                .flatMap { Observable.from($0) }
                .map { SearchSectionItem.result($0)}
                .toArray().asObservable()
                .map { [SearchSection.section(items: $0)] }
                .map { Mutation.setResultSections($0) }
            
            return search
                .concat(Observable.just(Mutation.setShowResultView(true)))
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
        case let .setResultSections(resultSections):
            newState.resultSections = resultSections
            return newState
        case let .setShowResultView(showResultView):
            newState.showResultView = showResultView
            return newState
        }
    }
    
}

extension SearchViewReactor {
    private func convertModel(_ models: [SearchResult]) -> [SearchResultCellReactor.Data] {
        models.compactMap({ (result) -> SearchResultCellReactor.Data in
            
            let userCount = result.userRatingCountForCurrentVersion ?? 0
            let max = userCount >= 10000 ? 2 : 3
            let regexResult = GlobalFunc
                .regex("\(userCount)", pattern: "^[0-9]{1,\(max)}[^0]$")
            
            var toArray = (regexResult.first ?? "0").map { $0 }
            if toArray.count > 1 {
                toArray.insert(".", at: 1)
            }
            var userRatingCount = toArray.map { String($0) }.joined()
            
            switch userCount {
            case 1000..<10000:
                userRatingCount.append("천")
            case 10000...:
                userRatingCount.append("만")
            default:
                break
            }
            
            let screenshotUrls = result.screenshotUrls?
                .compactMap { URL(string: $0) }
            
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            
            let averageUserRatingForCurrentVersion = numberFormatter.string(from: (result.averageUserRatingForCurrentVersion ?? 0)
                as NSNumber) ?? "0"
             
            return SearchResultCellReactor.Data(
                artworkUrl60: URL(string: (result.artworkUrl60 ?? "")),
                trackName: result.trackName,
                description: result.description,
                averageUserRatingForCurrentVersion: Double(averageUserRatingForCurrentVersion),
                userRatingCountForCurrentVersion: averageUserRatingForCurrentVersion,
                screenshotUrls: screenshotUrls
            )
        })
    }
}
