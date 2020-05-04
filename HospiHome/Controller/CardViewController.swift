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
    
    var cardNames = ["Notification", "Settings", "Help", "Give us feedback", "Log out"]
    var cardIcons = ["bell.fill", "", "info", "bubble.left.fill", "arrow.left"]
    override func viewDidLoad() {
        super.viewDidLoad()
        if profile?.accountType == AccountType.Doctor{
            cardNames.append("Create/Update Schedule")
            cardIcons.append("")
        }
        setupViews()
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
            let loginViewController = self.parent?.storyboard?.instantiateViewController(identifier: "schedule") as! CreateScheduleViewController
        loginViewController.modalPresentationStyle = .fullScreen
        self.present(loginViewController, animated: true, completion: nil)
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
        }
        
        if cardNames[indexPath.row] == "Create/Update Schedule"{
            navigateToScheduleVC()
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProfileCell
        
        cell.nameLabel.text = cardNames[indexPath.row]
        
        if indexPath.row == 1 {
            cell.imageName.image = UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate)
        } else {
            cell.imageName.image = UIImage(systemName: cardIcons[indexPath.row])
        }
        
        cell.tintColor = .gray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

