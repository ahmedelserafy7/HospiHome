//
//  HomeViewController.swift
//  HospiHome
//
//  Created by Elser_10 on 5/1/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var menuBar: MenuBar!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let cellId = "cellId"
    let searchController = UISearchController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarSetup()
        
        menuBar.homeController = self
        menuBar.showCollectionView()
        
        navigationItem.title = "Home"
        
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func searchBarSetup() {
        
        searchController.searchBar.delegate = self
        
        searchController.searchBar.placeholder = "Search Doctors"
        
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
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
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let drProfileViewController = storyboard?.instantiateViewController(identifier: "dr") as! DrProfileViewController
        navigationController?.pushViewController(drProfileViewController, animated: true)
    }
    
}
