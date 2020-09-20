//
//  CAGradientLayer+Extensions.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/20.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit.UIColor

extension CAGradientLayer {
    convenience init(frame: CGRect,
                     startPoint: CGPoint,
                     endPoint: CGPoint,
                     colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.colors = colors.map { $0.cgColor }
        self.shouldRasterize = true
    }
}
