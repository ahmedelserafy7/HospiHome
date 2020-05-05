//
//  CardViewController.swift
//  HospiHome
//
//  Created by Elser_10 on 5/1/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    
    @IBOutlet weak var moveAreaView: UIView!
    
    fileprivate let cellId = "cellId"
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    var cardNames = ["Notification", "Settings", "Help", "Give us feedback", "About", "Log out"]
    var cardIcons: [UIImage] = [UIImage(systemName: "bell.fill")!, UIImage(systemName: "gear")!, UIImage(systemName: "questionmark.circle.fill")!, UIImage(systemName:"bubble.left.fill")!, UIImage(systemName: "info")!, UIImage(systemName: "arrow.left")!]
//        ["bell.fill", "", "info", "bubble.left.fill", "arrow.left"]
    override func viewDidLoad() {
        super.viewDidLoad()
        if profile?.accountType == AccountType.Doctor{
            cardNames.append("Create/Update Schedule")
            cardIcons.append(UIImage(systemName: "calendar")!)
            
            cardNames.append("Check My Balance")
            cardIcons.append(UIImage(systemName: "dollarsign.circle.fill")!)
        }
        
        setupViews()
    }
    
    func fetchBalance(){
        API().httpGETRequest(endpoint: .balance) { (data, error) in
            if let data = data{
                let response = try? JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Result", message: response?.msg, preferredStyle: .alert)
                           alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.parent?.present(alert, animated: true) {
                           }
                       }
            }
        }
    }
    
    func setupViews() {
        tableView.register(ProfileCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func logout(){
        API().httpGETRequest(endpoint: .logout) { (data, error) in  }
        navigateToLoginVC()
    }
    
    func navigateToLoginVC() {
        DispatchQueue.main.async {
            let loginViewController = self.parent?.storyboard?.instantiateViewController(identifier: "login") as! LoginViewController
            loginViewController.modalPresentationStyle = .fullScreen
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
    
    func navigateToScheduleVC() {
        DispatchQueue.main.async {
            let scheduleViewController = self.parent?.storyboard?.instantiateViewController(identifier: "schedule") as! CreateScheduleViewController
        scheduleViewController.modalPresentationStyle = .fullScreen
        self.present(scheduleViewController, animated: true, completion: nil)
        }
    }
    
    func navigateAboutVC() {
        DispatchQueue.main.async {
            let aboutViewController = self.parent?.storyboard?.instantiateViewController(identifier: "about") as! AboutViewController
            self.navigationController?.pushViewController(aboutViewController, animated: true)
        }
    }
    
}

extension CardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardNames.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cardNames[indexPath.row] == "Log out"{
            self.logout()
        } else if cardNames[indexPath.row] == "Create/Update Schedule"{
            navigateToScheduleVC()
        } else if cardNames[indexPath.item] == "About" {
            navigateAboutVC()
        }
        else if cardNames[indexPath.item] == "Check My Balance"{
            fetchBalance()
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProfileCell
        
        cell.nameLabel.text = cardNames[indexPath.row]
        
        if indexPath.row == 1 {
            cell.imageName.image = UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate)
        } else {
            cell.imageName.image = cardIcons[indexPath.row]
        }
        
        cell.tintColor = .gray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

