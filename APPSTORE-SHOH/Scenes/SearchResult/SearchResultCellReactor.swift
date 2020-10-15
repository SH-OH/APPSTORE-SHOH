//
//  SearchResultCellReactor.swift
//  APPSTORE-SHOH
//
//  Created by Oh Sangho on 2020/09/19.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import Foundation
import ReactorKit
import UIKit

final class SearchResultCellReactor: Reactor {
    
    struct Data {
        let artworkUrl60: URL?
        let trackName: String?
        let description: String?
        let ratingArray: [Double]
        let userRatingCount: String?
        let screenshotUrls: [URL]?
    }
    
    enum Action {
        case open
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var artworkUrl: URL?
        var trackName: String?
        var description: String?
        var rating: [Double]
        var userRatingCount: String?
        var screenshotUrls: [URL]?
    }
    
    let initialState: State
    let navigationController: UINavigationController
    
    init(data: Data, navigationController: UINavigationController) {
        self.initialState = .init(
            artworkUrl: data.artworkUrl60,
            trackName: data.trackName,
            description: data.description,
            rating: data.ratingArray,
            userRatingCount: data.userRatingCount,
            screenshotUrls: data.screenshotUrls
        )
        self.navigationController = navigationController
    }
    
}
