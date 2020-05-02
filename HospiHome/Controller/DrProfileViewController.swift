//
//  DrProfileViewController.swift
//  HospiHome
//
//  Created by Elser_10 on 5/2/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class DrProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        hideWhenSwipe()
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func hideWhenSwipe() {
        self.navigationController?.hidesBarsOnSwipe = true
    }
}
