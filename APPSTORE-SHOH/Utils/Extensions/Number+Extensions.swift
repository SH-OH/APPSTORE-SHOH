//
//  Number+Extensions.swift
//  APPSTORE-SHOH
//
//  Created by Oh Sangho on 2020/09/20.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import Foundation

extension Int {
    var userCountToSpell: String {
        guard self > 0 else { return "0" }
        let max = self >= 10000 ? 2 : 3
        let prefix = String(
            "\(self)".prefix(max)
        )
        
        var toArray = prefix.map { $0 }
        if
            toArray.last == "0"
                || toArray.last == "."
        {
            while
                toArray.last == "0"
                    || toArray.last == "."
            {
                toArray = toArray.dropLast()
            }
        }
        
        if
            toArray.count > 1
                && self >= 1000
                && self < 100000
        {
            toArray.insert(".", at: 1)
        }
        
        var userRatingCount = toArray
            .map { String($0) }
            .joined()
        
        switch self {
        case 1000..<10000:
            userRatingCount.append("천")
        case 10000...:
            userRatingCount.append("만")
        default:
            break
        }
        return userRatingCount
    }
    var toDecimal: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: self as NSNumber) ?? "0"
    }
}
