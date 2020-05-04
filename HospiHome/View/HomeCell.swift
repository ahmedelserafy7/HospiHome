//
//  HomeCell.swift
//  HospiHome
//
//  Created by Elser_10 on 5/1/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    @IBOutlet var feesLabel: UILabel!
    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var bookButton: UIButton!
    
    var parent: UIViewController?
    var doctor: Doctor?
    
    override func awakeFromNib() {

    }

    func navigateToBookVC() {
        let reservationViewController = self.parent!.storyboard?.instantiateViewController(identifier: "book") as! ReservationViewController
        reservationViewController.doctor = self.doctor!
        self.parent!.navigationController?.pushViewController(reservationViewController, animated: true)
        
    }
    
    @IBAction func bookButtonTapped(_ sender: Any) {
        navigateToBookVC()
    }
}
