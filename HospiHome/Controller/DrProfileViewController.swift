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
    @IBOutlet var bookButton: UIButton!
    @IBOutlet var avatarImageView: UIImageView!
    var doctor: Doctor?
    var soonestReservation: Reservation?
    @IBOutlet var connectToDoctor: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        hideWhenSwipe()
        
        fetchDrProfileDetails()
        checkIfUserHaveReservation()
    }
    
    func checkIfUserHaveReservation(){
        let parameters = ["doctorid": doctor!.info.id]
        
        API().httpPOSTRequest(endpoint: .soonestReservation, postData: parameters) { (data, error) in
            guard let data = data else{self.alertError(withTitle: "Unable to check for reservations", withMessage: "Unknown Response from server, please try again later");return;}
            
            let reservationResponse = try? JSONDecoder().decode(SoonestReservationResponse.self, from: data)
            
            DispatchQueue.main.async {
                if let response = reservationResponse{
                    if response.success{
                        self.bookButton.isHidden = true
                        let reservation = response.reservation!
                        let currentTimestamp = NSDate().timeIntervalSince1970
                        if (Int(currentTimestamp) < Int(reservation.time)!-3600){
                            self.connectToDoctor.backgroundColor = .lightGray
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat="dd/MM/yyyy HH:mm"
                            
                          
                            let timeString = dateFormatter.string(from:  Date(timeIntervalSince1970: TimeInterval(exactly: Double(reservation.time)!)!))

                            
                           

                            self.connectToDoctor.titleLabel!.minimumScaleFactor = 0.2
                            self.connectToDoctor.titleLabel!.adjustsFontSizeToFitWidth = true
                            self.connectToDoctor.setTitle(timeString, for: .normal)
                            
                        }
                        self.connectToDoctor.isHidden = false
                        self.connectToDoctor.isEnabled = true
                        self.soonestReservation = reservation
                        
                    }
                    }
                }
                
            }
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
    
    @IBAction func connectButtonTapped(_ sender: Any) {
        let videoChatViewController = self.parent!.storyboard?.instantiateViewController(identifier: "videochat") as! VideoChatViewController
        videoChatViewController.reservation = soonestReservation
        self.navigationController?.pushViewController(videoChatViewController, animated: true)
    }
    
    func alertError(withTitle: String,withMessage: String){
        DispatchQueue.main.async {
        let alert = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func bookTapped(_ sender: Any) {
        navigateToBookVC()
    }
    
    func hideWhenSwipe() {
        self.navigationController?.hidesBarsOnSwipe = true
    }
}
