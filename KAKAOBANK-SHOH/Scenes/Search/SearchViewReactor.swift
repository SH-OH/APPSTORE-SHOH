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
    
    enum Action {
        case recentFind(text: String)
        case showResult(text: String?)
    }
    
    enum Mutation {
        case setSearchedSections([SearchSection])
        case setFoundSections([SearchSection])
        case setShowResultView(Bool)
        case setCurSearchBarValue(String)
    }
    
    
    struct State {
        var searchedSections: [SearchSection]
        var foundSections: [SearchSection]
        var showResultView: Bool
        var curSearchBarValue: String
    }
    
    let initialState: State
//    let searchBarValueRelay: PublishRelay<String?>
    
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
            showResultView: false,
            curSearchBarValue: ""
        )
//        self.searchBarValueRelay = .init()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .recentFind(let responseText):
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
                .map { [SearchSection.section(items: $0)] }
                .map { Mutation.setFoundSections($0)}
            return find
                .concat(Observable.just(Mutation.setCurSearchBarValue(responseText)))
        case .showResult(let responseText):
            let setShowResultView: Observable<Mutation> = Observable.just(responseText)
                .map { !($0?.isEmpty ?? true) }
                .map { Mutation.setShowResultView($0) }
            
            return setShowResultView
                .concat(Observable.just(Mutation.setCurSearchBarValue(responseText ?? "")))
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
        case let .setShowResultView(showResultView):
            newState.showResultView = showResultView
            return newState
        case let .setCurSearchBarValue(curSearchBarValue):
            newState.curSearchBarValue = curSearchBarValue
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
