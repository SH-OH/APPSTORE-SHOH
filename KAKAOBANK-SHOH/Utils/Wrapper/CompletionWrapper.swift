//
//  CompletionWrapper.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/28.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import Foundation

final class CompletionWrapper<Element> {
    
    private var completion: ((Element) -> Void)?
    private let defaultValue: Element
    
    init(completion: @escaping ((Element) -> Void), defaultValue: Element) {
        self.completion = completion
        self.defaultValue = defaultValue
    }
    
    func result(_ value: Element) {
        completion?(value)
        completion = nil
    }
    
    deinit {
        result(defaultValue)
    }
}
