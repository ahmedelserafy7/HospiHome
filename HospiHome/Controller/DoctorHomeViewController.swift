//
//  DoctorHomeViewController.swift
//  HospiHome
//
//  Created by Seif Elmenabawy on 5/5/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class DoctorHomeViewController: UIViewController {
    
    

    
    var reservationsArray = [Reservation]()
    
    var filteredArray = [Reservation](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
   @IBOutlet var searchBar: UISearchBar!
   @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        searchBarSetup()
        fetchMyReservations()
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func fetchMyReservations(){
        API().httpGETRequest(endpoint: .getMyReservations) { (data, error) in
            guard let data = data else{self.alertError(withTitle: "Unable to check for reservations", withMessage: "Unknown Response from server, please try again later");return;}
            
             
            
            let reservationResponse = try? JSONDecoder().decode(DoctorReservationsResponse.self, from: data)
            
            DispatchQueue.main.async {
                if let response = reservationResponse{
                    if response.success{
                        self.reservationsArray = response.reservations!
                        self.filteredArray = self.reservationsArray
                    }
                    }
                }
            
        }
    }
    
    
    
    
    func setupNavBar() {
           navigationItem.title = "My Reservations"
       }
    
    func searchBarSetup() {
           searchBar.delegate = self
           searchBar.searchTextField.delegate = self
           searchBar.placeholder = "Search Reservations"
           searchBar.backgroundImage = UIImage()
           
           UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor(r: 240, g: 240, b: 240)
       }


}

// MARK: UISearchBar
extension DoctorHomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
extension DoctorHomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
             filteredArray = reservationsArray
            return
        }
        let searchText = searchBar.searchTextField.text!
               if !searchText.isEmpty {
                   filteredArray = reservationsArray.filter { (reservation) -> Bool in
                    let dateFormatter = DateFormatter()
                       dateFormatter.dateFormat="EEEE dd/MM/yyyy HH:mm"
                    let timeString = dateFormatter.string(from:  Date(timeIntervalSince1970: TimeInterval(exactly: Double(reservation.time)!)!))
                    return reservation.patientName!.contains(searchText) || timeString.contains(searchText)
                   }
               }
               self.tableView.reloadData()
           }
    }
    


// MARK: TableViewDelegate, and DataSource
extension DoctorHomeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reservationcell", for: indexPath) as! ReservationCell
        cell.nameLabel.text = filteredArray[indexPath.section].patientName
        let dateFormatter = DateFormatter()
           dateFormatter.dateFormat="EEEE dd/MM/yyyy HH:mm"
        let timeString = dateFormatter.string(from:  Date(timeIntervalSince1970: TimeInterval(exactly: Double(filteredArray[indexPath.section].time)!)!))
        cell.timeLabel.text = timeString
        cell.reservationNumberLabel.text = "Reservation #" + filteredArray[indexPath.section].id
         if (Int(NSDate().timeIntervalSince1970) > Int(filteredArray[indexPath.section].time)!-3600){
        cell.connectButton.isHidden = false
        }
         else{
             cell.connectButton.isHidden = true
        }
        cell.reservation = filteredArray[indexPath.section]
        cell.parentController = self
       return cell
    }
    
    
    func alertError(withTitle: String,withMessage: String){
        DispatchQueue.main.async {
        let alert = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
        }
    }
    
}
