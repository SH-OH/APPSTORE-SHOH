//
//  GlobalFunc.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/19.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import Foundation

final class GlobalFunc {
    class func regex(_ target: String,
                     pattern: String,
                     options: NSRegularExpression.Options = [])
        -> [String] {
            do {
                let regex = try NSRegularExpression(pattern: pattern,
                                                    options: options)
                let range = NSRange(target.startIndex..., in: target)
                let regexResults = regex.matches(in: target,
                                                 options: [],
                                                 range: range)
                return regexResults.compactMap { result -> String? in
                    guard let range = Range(result.range, in: target) else { return nil }
                    return String(target[range])
                }
            } catch {
                print(error)
                return []
            }
    }
}
