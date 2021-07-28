//
//  UIColor+Ext.swift
//  FoodPin
//
//  Created by 則佑林 on 2020/12/2.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let redValue = CGFloat(red) / 255.0
        let greenValue = CGFloat(green) / 255.0
        let blueValue = CGFloat(blue) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: 0.8)
    }
}
