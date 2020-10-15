//
//  BaseViewController.swift
//  APPSTORE-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    var disposeBag: DisposeBag = .init()
    
    deinit {
        print("[👋deinit]\(String(describing: self))")
    }
    
}
