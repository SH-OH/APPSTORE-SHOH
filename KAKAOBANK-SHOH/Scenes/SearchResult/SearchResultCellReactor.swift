//
//  SearchResultCellReactor.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/19.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import Foundation
import ReactorKit

final class SearchResultCellReactor: Reactor {
    
    struct Data {
        let artworkUrl60: URL?
        let trackName: String?
        let description: String?
        let averageUserRatingForCurrentVersion: Double?
        let userRatingCountForCurrentVersion: String?
        let screenshotUrls: [URL]?
    }
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var artworkUrl: URL?
        var trackName: String?
        var description: String?
        var rating: Double?
        var userRatingCount: String?
        var screenshotUrls: [URL]?
    }
    
    let initialState: State
    
    init(data: Data) {
        self.initialState = .init(
            artworkUrl: data.artworkUrl60,
            trackName: data.trackName,
            description: data.description,
            rating: data.averageUserRatingForCurrentVersion,
            userRatingCount: data.userRatingCountForCurrentVersion,
            screenshotUrls: data.screenshotUrls
        )
    }
    
}
