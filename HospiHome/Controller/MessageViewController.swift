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
        
        setupNavTitleView()
        
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
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
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MessageCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let chatController = storyboard?.instantiateViewController(identifier: "chat") as! ChatViewController
        let chatViewController = ChatViewController()
        navigationController?.pushViewController(chatViewController, animated: true)
        
    }
    
}

