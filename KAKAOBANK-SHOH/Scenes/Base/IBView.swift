//
//  IBView.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/19.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import UIKit.UIView

@IBDesignable
class IBButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    @IBInspectable var borderColor: UIColor {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue.cgColor }
    }
}

@IBDesignable
class IBImageView: UIImageView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    @IBInspectable var borderColor: UIColor {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue.cgColor }
    }
}

@IBDesignable
class IBView: UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    @IBInspectable var borderColor: UIColor {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue.cgColor }
    }
     @IBInspectable var setGradient: UIColor {
        get { return backgroundColor ?? UIColor.white }
        set { setGradient(newValue) }
    }
    private func setGradient(_ gradientColor: UIColor) {
        let colors: [UIColor] = [
            gradientColor.withAlphaComponent(0.25),
            gradientColor.withAlphaComponent(1)
        ]
        
        let leftGrad: CAGradientLayer = CAGradientLayer()
        leftGrad.frame = self.bounds
        leftGrad.startPoint = CGPoint(x: 0, y: 1)
        leftGrad.endPoint = CGPoint(x: 1, y: 1)
        leftGrad.colors = colors.map { $0.cgColor }
        leftGrad.shouldRasterize = true
        
        self.layer.addSublayer(leftGrad)
    }
}
