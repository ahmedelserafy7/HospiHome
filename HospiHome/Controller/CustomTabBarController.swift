//
//  CustomTabBarController.swift
//  HospiHome
//
//  Created by Elser_10 on 4/30/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        tabBar.tintColor = UIColor(r: 0, g: 199, b: 154)
//            UIColor(r: 0, g: 199, b: 254)
        tabBar.unselectedItemTintColor = UIColor(r: 70, g: 70, b: 70)
    }
}
