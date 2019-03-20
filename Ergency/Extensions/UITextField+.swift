//
//  UITextField+.swift
//  Euphoria
//
//  Created by Guduru, Pradeep(AWF) on 2/9/19.
//  Copyright © 2019 Guduru, Pradeep(AWF). All rights reserved.
//

import UIKit

extension UITextField {
    
    func setPaddingPointsOnLeft(_ left:CGFloat, andRight right:CGFloat){
        self.setLeftPaddingPoints(left)
        self.setRightPaddingPoints(right)
    }
    
    func setLeftPaddingPoints(_ value:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ value:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func desginView(left:CGFloat = 14, right:CGFloat = 14) {
        self.setPaddingPointsOnLeft(left, andRight: right)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 5.0
        self.layer.shadowColor = UIColor.singleColor(value: 74, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 2)
        self.layer.shadowRadius = 2.0
        self.layer.shouldRasterize = true
        self.layer.shadowOpacity = 1.0
        self.layer.sublayerTransform = CATransform3DMakeTranslation(0, 7, 0)
    }
}

