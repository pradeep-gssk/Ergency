//
//  UIColor+.swift
//  Ergency
//
//  Created by Guduru, Pradeep(AWF) on 1/28/19.
//  Copyright © 2019 Guduru, Pradeep(AWF). All rights reserved.
//

import UIKit

extension UIColor {
    var red : CGFloat {
        get {
            let components = self.cgColor.components
            return components?[0] ?? 0
        }
    }
    
    var green : CGFloat {
        get {
            let components = self.cgColor.components
            return components?[1] ?? 0
        }
    }
    
    var blue : CGFloat {
        get {
            let components = self.cgColor.components
            return components?[2] ?? 0
        }
    }
    
    var alpha : CGFloat {
        get {
            return self.cgColor.alpha
        }
    }
    
    func white(rate: CGFloat) -> UIColor {
        return UIColor (
            red: self.red + (1.0 - self.red) * rate,
            green: self.green + (1.0 - self.green) * rate,
            blue: self.blue + (1.0 - self.blue) * rate,
            alpha: 1.0
        )
    }
    
    class func singleColor(value: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: (value/255.0), green: (value/255.0), blue: (value/255.0), alpha: alpha)
    }
}

