//
//  MainTabBarViewReactor.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import ReactorKit

final class MainTabBarViewReactor: Reactor {
    
    typealias Action = NoAction
    
    enum Mutation {
    }
    
    struct State {
    }
    
    let initialState: State
    
    init() {
        self.initialState = .init()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        return newState
    }
    
}
