//
//  AppLaunch.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit.UIWindow

final class AppLaunch {
    static func launchByOS(isScene: Bool) {
        
        var _window: UIWindow!
        
        if #available(iOS 13.0, *) {
            guard isScene else { return }
            _window = UIApplication.shared.windows.first
        } else {
            _window = UIApplication.shared.windows.first
        }
        
        let tabBar = StoryboardType.Main.viewController(MainTabBarController.self)
        tabBar.reactor = MainTabBarViewReactor()
        _window.rootViewController = tabBar
        
        return
    }
}
