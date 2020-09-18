//
//  Array+Extensions.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
}
