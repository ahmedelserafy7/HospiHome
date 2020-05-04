//
//  HomeViewController.swift
//  HospiHome
//
//  Created by Elser_10 on 5/1/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var doctorsArray = [Doctor]()
    
    var filteredArray = [Doctor](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var specialitiesArray = [Speciality](){
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    fileprivate var filterButtons = [UIButton]()
    fileprivate var allButton: UIButton?
    fileprivate var lastSelectedFilterButton: UIButton?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    
    fileprivate let cellId = "cellId"
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.estimatedRowHeight = 110
        tableView.separatorColor = UIColor.clear
        tableView.rowHeight = UITableView.automaticDimension
        fetchSpecialities()
        fetchDoctorsList()
    }
    
    func setupNavBar() {
        navigationItem.title = "Home"
    }
    
    func filterContentForSepciality(_ specialityString: String) {
  
        tableView.reloadData()
    }
    
    @objc func filterButtonTapped(_ sender: UIButton) {
        lastSelectedFilterButton = sender
        searchBar.resignFirstResponder()
        filterResults()
        setAllButtonsAsUnclickedExcept(sender)
    }
    
    //Filter button UI Modifiers
    func setButtonAsClicked(_ button: UIButton){
        button.backgroundColor = UIColor.systemPink
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    func setAllButtonsAsUnclickedExcept(_ button: UIButton){
        for buttono in filterButtons{
            buttono.backgroundColor = UIColor.white
            buttono.setTitleColor(UIColor.black, for: .normal)
        }
        setButtonAsClicked(button)
    }
    
    
    func fetchDoctorsList(){
        API().httpGETRequest(endpoint: .fetchDoctors ){ (data, error) in
            guard let data = data else{self.alertError(withMessage: "Unknown Response from server, please try again later");return;}
            
            if let doctorsResponse = try? JSONDecoder().decode(FetchDoctorsResponse.self, from: data){
                self.doctorsArray = doctorsResponse.doctors
                self.filteredArray =  self.doctorsArray
            }
            else{
                self.alertError(withMessage: "An error occured while fetching doctors list, please try again later");
                return;
            }
        }
    }
    
    func fetchSpecialities(){
        API().httpGETRequest(endpoint: .fetchSpecialaities) { (data, error) in
            guard let data = data else{self.alertError(withMessage: "Unknown Response from server, please try again later");return;}
            
            if let specialitiesResponse = try? JSONDecoder().decode(SepcialitiesResponse.self, from: data){
                self.specialitiesArray = [Speciality(name: "All")] + specialitiesResponse.specialities
            }
            else{
                self.alertError(withMessage: "An error occured while fetching specialities list, please try again later");
                return;
            }
        }
    }
    
    func filterResults(){
        
        if String(lastSelectedFilterButton!.title(for: .normal)!) == "All"{
            filteredArray = doctorsArray
        }
        else
        {
          filteredArray = doctorsArray.filter { (doctor) -> Bool in
            doctor.info.speciality == (lastSelectedFilterButton!.title(for: .normal)!)
        }
        }
        
        let searchText = searchBar.searchTextField.text!
        if !searchText.isEmpty {
           filteredArray = filteredArray.filter { (doctor) -> Bool in
                doctor.info.name.contains(searchText)
            }
        }
           self.tableView.reloadData()
    }
}

// MARK: UISearchBar
extension HomeViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
        }
}
extension HomeViewController: UISearchBarDelegate {


    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
   filterResults()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchController.isActive {
            filteredArray = doctorsArray
            self.tableView.reloadData()
        }
    }
}

// MARK: TableViewDelegate, and DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeCell
        cell.bioLabel.text? = filteredArray[indexPath.section].info.bio
               cell.nameLabel.text? = filteredArray[indexPath.section].info.name
               cell.feesLabel.text? = filteredArray[indexPath.section].info.fees + " EGP"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        let drProfileViewController = storyboard?.instantiateViewController(identifier: "dr") as! DrProfileViewController
        drProfileViewController.doctor = filteredArray[indexPath.row]
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.specialitiesArray.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    
    let installedButtons = cell.contentView.subviews.filter{$0 is UIButton}
         if installedButtons.count>0, let installedButton = installedButtons[0] as? UIButton{
             installedButton.removeFromSuperview()
             filterButtons.removeAll { (button: UIButton) -> Bool in
                 return button == installedButton
             }
         }
         
         let button = UIButton()
         button.translatesAutoresizingMaskIntoConstraints = false
         button.setTitleColor(UIColor.black, for: .normal)
         button.titleLabel?.font = button.titleLabel?.font.withSize(13)
         button.widthAnchor.constraint(equalToConstant: 99).isActive = true
         button.heightAnchor.constraint(equalToConstant: 38).isActive = true
         button.layer.cornerRadius = 7
         button.layer.borderWidth = 1
         button.layer.borderColor = UIColor.black.cgColor
        button.setTitle(specialitiesArray[indexPath.row].name, for: .normal)
         button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
         
         
         cell.contentView.addSubview(button)
         
         filterButtons.append(button)
         
         if (button.titleLabel?.text == "All"){ allButton = button}
         
         if let selectedButton = lastSelectedFilterButton {
             if(selectedButton.titleLabel?.text == button.titleLabel?.text){
                 setButtonAsClicked(button)
             }
         }
         else{
             setButtonAsClicked(allButton!)
              lastSelectedFilterButton = allButton!
         }
    
    
    return cell
}
}
