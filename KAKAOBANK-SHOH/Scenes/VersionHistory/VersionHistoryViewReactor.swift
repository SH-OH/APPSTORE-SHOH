//
//  VersionHistoryViewReactor.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/21.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import ReactorKit

final class VersionHistoryViewReactor: Reactor {
    
    typealias Action = NoAction
    
    typealias Mutation = NoMutation
    
    struct State {
        var sections: [VersionHistorySection]
    }
    
    let initialState: State
    
    init(items: [VersionHistorySectionItem]) {
        self.initialState = State(
            sections: [VersionHistorySection.version(items)]
        )
    }
    
}
