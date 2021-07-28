//
//  UINavigationController+Ext.swift
//  FoodPin
//
//  Created by 則佑林 on 2020/12/2.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    //複寫childForStatusBarStyle屬性的值
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
