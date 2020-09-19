//
//  SearchResultViewReactor.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/19.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import ReactorKit
import Foundation

final class SearchResultViewReactor: Reactor {
    enum Action {
        case search(reponseText: String)
    }
    
    enum Mutation {
        case setResponseText(String)
        case setResultSections([SearchSection])
    }
    
    struct State {
        var responseText: String = ""
        var resultSections: [SearchSection] = []
    }
    
    let initialState: State
    let searchViewReactor: SearchViewReactor
    
    init(searchViewReactor: SearchViewReactor) {
        self.initialState = .init()
        self.searchViewReactor = searchViewReactor
        print("[init!!!]\(String(describing: self))")
    }
    
    deinit {
        print("[👋deinit]\(String(describing: self))")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .search(let responseText):
            let search: Observable<Mutation> = SearchUseCase()
                .search(responseText)
                .compactMap { $0.results }
                .asObservable()
                .compactMap { [weak self] in self?.convertModel($0) }
                .flatMap { Observable.from($0) }
                .map { SearchSectionItem.result($0) }
                .toArray().asObservable()
                .map { [SearchSection.result($0)] }
                .map { Mutation.setResultSections($0) }
            
            return search
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let setResponseText: Observable<Mutation> = searchViewReactor.curShowType
            .filter { $0 == .검색결과화면 }
            .withLatestFrom(searchViewReactor.state.map { $0.curSearchBarValue})
            .distinctUntilChanged()
            .map { Mutation.setResponseText($0)}
        
        return Observable.merge(mutation, setResponseText)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setResultSections(let resultSections):
            newState.resultSections = resultSections
            return newState
        case .setResponseText(let responseText):
            newState.responseText = responseText
            return newState
        }
    }
}

extension SearchResultViewReactor {
    private func convertModel(_ models: [SearchResult]) -> [SearchResultCellReactor.Data] {
        let now = Date()
        return models.compactMap({ (result) -> SearchResultCellReactor.Data in
            
            let userCount = result.userRatingCountForCurrentVersion ?? 0
            let max = userCount >= 10000 ? 2 : 3
            let regexResult = GlobalFunc
                .regex("\(userCount)", pattern: "^[0-9]{1,\(max)}[^0]$")
            
            var toArray = (regexResult.first ?? "0").map { $0 }
            if toArray.count > 1, userCount >= 1000 {
                toArray.insert(".", at: 1)
            }
            var userRatingCount = toArray
                .map { String($0) }
                .joined()
            
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
                userRatingCountForCurrentVersion: userRatingCount,
                screenshotUrls: screenshotUrls,
                updateDate: now
            )
        })
    }
}
