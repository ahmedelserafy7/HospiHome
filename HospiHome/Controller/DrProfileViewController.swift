//
//  DrProfileViewController.swift
//  HospiHome
//
//  Created by Elser_10 on 5/2/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class DrProfileViewController: UIViewController {
    @IBOutlet var feesLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    var doctor: Doctor?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupNavBar()
        hideWhenSwipe()
        
        
        fetchDrProfileDetails()
    }
    
    func fetchDrProfileDetails() {
        if let doctor = doctor {
            feesLabel.text = doctor.info.fees + " EGP"
            bioLabel.text = doctor.info.bio
            nameLabel.text = doctor.info.name
            if let image = doctor.info.image{
                avatarImageView.image = UIImage(data: image)
            }
        }
    }
    

    
    func setupNavBar() {
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func hideWhenSwipe() {
        self.navigationController?.hidesBarsOnSwipe = true
    }
}
