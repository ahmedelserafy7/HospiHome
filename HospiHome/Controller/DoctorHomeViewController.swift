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
        tableView.estimatedRowHeight = 110
        tableView.separatorColor = UIColor.clear
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        //filterResults()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reservationcell", for: indexPath) as! HomeCell
//        cell.parent = self
//        cell.doctor = filteredArray[indexPath.section]
//        cell.bioLabel.text? = self.filteredArray[indexPath.section].info.bio
//        cell.nameLabel.text? = self.filteredArray[indexPath.section].info.name
//        cell.feesLabel.text? = self.filteredArray[indexPath.section].info.fees + " EGP"
//        if let image = self.filteredArray[indexPath.row].info.image{cell.avatarView.image = UIImage(data: image)}
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
//        let drProfileViewController = storyboard?.instantiateViewController(identifier: "dr") as! DrProfileViewController
//        drProfileViewController.doctor = filteredArray[indexPath.section]
//        navigationController?.pushViewController(drProfileViewController, animated: true)
    }
    
    func alertError(withMessage: String){
        DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: withMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
