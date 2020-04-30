//
//  ProfileViewController.swift
//  HospiHome
//
//  Created by Elser_10 on 4/30/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupNavigationItem()
    }
    
    func setupNavigationItem() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor(r: 38, g: 141, b: 255)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Profile"
    }
}
