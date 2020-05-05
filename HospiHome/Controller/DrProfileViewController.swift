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
        hideWhenSwipe()
        
        fetchDrProfileDetails()
    }
    
    func navigateToBookVC() {
        let reservationViewController = self.parent!.storyboard?.instantiateViewController(identifier: "book") as! ReservationViewController
        reservationViewController.doctor = self.doctor!
        self.navigationController?.pushViewController(reservationViewController, animated: true)
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
    @IBAction func bookTapped(_ sender: Any) {
        navigateToBookVC()
    }
    
    func hideWhenSwipe() {
        self.navigationController?.hidesBarsOnSwipe = true
    }
}
