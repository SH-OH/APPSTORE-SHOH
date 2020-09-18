//
//  SearchResultViewReactor.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/19.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import ReactorKit

final class SearchResultViewReactor: Reactor {
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    let initialState: State
    
    init() {
        self.initialState = .init()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        default:
            return newState
        }
    }
}
