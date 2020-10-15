//
//  MainTabBarController.swift
//  APPSTORE-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit.UITabBarController
import RxSwift
import Then
import ReactorKit

class MainTabBarController: UITabBarController, StoryboardView {
    
    var disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViewControllers()
    }
    
    private func createViewControllers() {
        var viewControllers: [UIViewController] = []
        let search = StoryboardType.Search.viewController(SearchViewController.self)
        
        viewControllers.append(search)
        let navs = viewControllers.map { vc -> UINavigationController in
            return UINavigationController(rootViewController: vc).then {
                $0.navigationBar.prefersLargeTitles = true
                $0.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
                $0.navigationBar.barTintColor = .white
                $0.navigationBar.shadowImage = UIImage()
            }
        }
        search.reactor = SearchViewReactor(navigationController: search.navigationController!)
        self.setViewControllers(navs, animated: false)
    }
    
    func bind(reactor: MainTabBarViewReactor) {
    }
}
