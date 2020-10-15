//
//  UILabel+Extensions.swift
//  APPSTORE-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit.UILabel

extension UILabel {
    func setAttributedText(_ text: String,
                           attrText: String,
                           attrs: [NSAttributedString.Key: Any]) {
        let attributedText = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: attrText)
        attributedText.addAttributes(attrs, range: range)
        self.attributedText = attributedText
    }
}
