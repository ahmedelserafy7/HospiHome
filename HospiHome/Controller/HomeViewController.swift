//
//  HomeViewController.swift
//  HospiHome
//
//  Created by Elser_10 on 5/1/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var doctorsArray = [Doctor](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var menuBar: MenuBar!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let cellId = "cellId"
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        searchBarSetup()
        
        menuBar.homeController = self
        menuBar.showCollectionView()
        
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension
        
        fetchDoctorsList()
    }
    
    func setupNavBar() {
        navigationItem.title = "Home"
    }
    
    func searchBarSetup() {
        
        searchController.searchBar.delegate = self
        
        searchController.searchBar.placeholder = "Search Doctors"
        
        searchController.obscuresBackgroundDuringPresentation = false

        definesPresentationContext = true
        
        
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor(r: 240, g: 240, b: 240)
        

        tableView.tableHeaderView = searchController.searchBar
    }
    
    func fetchDoctorsList(){
        API().httpGETRequest(urlString: "http://142.93.138.37/~hospihome/api/fetchDoctors.php") { (data, error) in
            guard let data = data else{self.alertError(withMessage: "Unknown Response from server, please try again later");return;}
            
            if let doctorsResponse = try? JSONDecoder().decode(FetchDoctorsResponse.self, from: data){
                self.doctorsArray = doctorsResponse.doctors
            }
            else{
                self.alertError(withMessage: "An error occured while fetching doctors list, please try again later");
                return;
            }
        }
    }
}

// MARK: UISearchBar
extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            
        } else {
            
        }
           self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchController.isActive {
            self.tableView.reloadData()
        }
    }
}

// MARK: TableViewDelegate, and DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return doctorsArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeCell
        cell.bioLabel.text? = doctorsArray[indexPath.section].info.bio
               cell.nameLabel.text? = doctorsArray[indexPath.section].info.name
               cell.feesLabel.text? = doctorsArray[indexPath.section].info.fees + " EGP"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        let drProfileViewController = storyboard?.instantiateViewController(identifier: "dr") as! DrProfileViewController
        navigationController?.pushViewController(drProfileViewController, animated: true)
    }
    
    func alertError(withMessage: String){
        DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: withMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
}
