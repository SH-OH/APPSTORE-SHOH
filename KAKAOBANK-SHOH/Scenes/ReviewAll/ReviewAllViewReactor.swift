//
//  ReviewAllViewReactor.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/21.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import ReactorKit
import RxCocoa

final class ReviewAllViewReactor: Reactor {
    
    enum SortType {
        case 도움, 호의, 비판, 최근
    }
    
    enum Action {
        case didSort(SortType)
    }
    
    enum Mutation {
        case setSortedSection([ReviewAllSection])
    }
    
    struct State {
        var sections: [ReviewAllSection]
    }
    
    let initialState: State
    let sortRelay: BehaviorRelay<SortType> = .init(value: .도움)
    
    init(items: [ReviewAllSectionItem]) {
        self.initialState = State(
            sections: [ReviewAllSection.review(items)]
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didSort(let type):
            guard let section = currentState.sections.first else { return .empty() }
            var sortedItem: [ReviewAllSectionItem] = section.items
            switch type {
            case .호의:
                sortedItem = section.items.sorted(by: { $0.rating > $1.rating })
            case .비판:
                sortedItem = section.items.sorted(by: { $0.rating < $1.rating })
            case .최근:
                sortedItem = section.items.sorted(by: { $0.updateDate > $1.updateDate })
            case .도움:
                break
            }
            return Observable.just(Mutation.setSortedSection([ReviewAllSection.review(sortedItem)]))
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSortedSection(let sorted):
            newState.sections = sorted
            return newState
        }
    }
}
