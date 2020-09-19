//
//  StoryboardType.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit

enum StoryboardType: String {
    case Main
    case Search
    case SearchResult
    case SearchDetail
    
    var initial: UIViewController {
        let storyboard = UIStoryboard.init(name: self.rawValue, bundle: .main)
        guard let viewController = storyboard.instantiateInitialViewController() else {
            preconditionFailure("Initial Storyboard : '\(self.rawValue)' init 실패")
        }
        return viewController
    }
    func viewController<T: UIViewController>(_ type: T.Type) -> T {
        let storyboard = UIStoryboard.init(name: self.rawValue, bundle: .main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "\(type)") as? T else {
            preconditionFailure("Storyboard : '\(type)' init 실패")
        }
        return vc
    }
}
