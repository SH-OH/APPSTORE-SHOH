//
//  UIImageView+Extensions.swift
//  APPSTORE-SHOH
//
//  Created by Oh Sangho on 2020/09/20.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit.UIImageView

extension UIImageView {
    func setRatingImage(_ rating: CGFloat) {
        var rating = rating
        rating = rating <= 0 ? 0 : rating
        rating = rating >= 1 ? 1 : rating
        let layer = CALayer()
        let w = self.frame.size.width*rating
        let h = self.frame.size.height
        layer.backgroundColor = UIColor.red.cgColor
        layer.frame = .init(x: 0, y: 0, width: w, height: h)
        self.layer.mask = layer
    }
}
