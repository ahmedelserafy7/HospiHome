//
//  ReservationCell.swift
//  HospiHome
//
//  Created by Seif Elmenabawy on 5/5/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class ReservationCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var reservation: Reservation?
    var parentController: UIViewController?
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var reservationNumberLabel: UILabel!
    @IBOutlet var connectButton: UIButton!
    
    @IBAction func connectButtonTapped(_ sender: Any) {
        let videoChatViewController = parentController?.storyboard?.instantiateViewController(identifier: "videochat") as! VideoChatViewController
        videoChatViewController.reservation = reservation!
        parentController?.navigationController?.pushViewController(videoChatViewController, animated: true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
