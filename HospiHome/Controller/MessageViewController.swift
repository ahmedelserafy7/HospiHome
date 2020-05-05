//
//  ViewController.swift
//  HospiHome
//
//  Created by Elser_10 on 4/29/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit
public var chatContacts = [Contact]()

class MessageViewController: UITableViewController {

    fileprivate let cellId = "cellId"
 
    @IBOutlet var noContactslabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavTitleView()
      getContacts()
 
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if(chatContacts.count == 0){
                self.noContactslabel.isHidden = false
                //self.tableView.isHidden=true
             }
        }
        super.viewWillAppear(true)
    }
    
    func getContacts(){
        API().httpGETRequest(endpoint: .getContactsList) { (data, error) in
            if let data = data{
                if let response = try? JSONDecoder().decode(GetContactsResponse.self, from: data){
                    chatContacts = response.contacts
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func setupNavTitleView() {
        let navTitleView = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 30, height: view.frame.height))
        navTitleView.text = "Chats"
        navTitleView.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        navigationItem.titleView = navTitleView
    }

}


extension MessageViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatContacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MessageCell
        cell.nameLabel.text = chatContacts[indexPath.row].name
        if let lastMsg = chatContacts[indexPath.row].lastmessage {
            cell.messageLabel.text? = lastMsg
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let chatController = storyboard?.instantiateViewController(identifier: "chat") as! ChatViewController
        let chatViewController = ChatViewController()
        chatViewController.recipientContact = chatContacts[indexPath.row]
        chatViewController.index = indexPath.row
        navigationController?.pushViewController(chatViewController, animated: true)
        
    }
    
}

