//
//  APIDomain.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import Foundation

enum APIDomain {
    case search
    
    var url: String {
        switch self {
        case .search:
            return "https://itunes.apple.com/search"
        }
    }
}
