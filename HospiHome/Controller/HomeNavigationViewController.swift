//
//  HomeNavigationViewController.swift
//  HospiHome
//
//  Created by Seif Elmenabawy on 5/5/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class HomeNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let profile = profile {
            if profile.accountType == AccountType.Doctor {
                let DoctorHomeVC = storyboard?.instantiateViewController(identifier: "doctorhome") as! DoctorHomeViewController
                self.pushViewController(DoctorHomeVC, animated: true)
            } else {
                let PatientHomeVC = storyboard?.instantiateViewController(identifier: "home") as! HomeViewController
                self.pushViewController(PatientHomeVC, animated: true)
            }
        }
    }
    
}
