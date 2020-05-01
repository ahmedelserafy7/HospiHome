//
//  ViewController.swift
//  HospiHome
//
//  Created by Elser_10 on 4/29/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class MessageViewController: UITableViewController {

    fileprivate let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        
        handleNavigationTitle()
    }
    
    func handleNavigationTitle() {
       let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        titleView.backgroundColor = .red
        
        let profileImageView = UIImageView(image: #imageLiteral(resourceName: "elon"))
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        
        titleView.addSubview(profileImageView)
        
        profileImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: titleView.leftAnchor, constant: 8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Ahmed Samir Elserafy"
        
        titleView.addSubview(nameLabel)
        
        nameLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        navigationItem.titleView = titleView
    }
}

extension MessageViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MessageCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatController = storyboard?.instantiateViewController(identifier: "chat") as! ChatViewController
        navigationController?.pushViewController(chatController, animated: true)
        
    }
    
}

