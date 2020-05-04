//
//  ArticlesViewController.swift
//  HospiHome
//
//  Created by Elser_10 on 4/30/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class ArticlesViewController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.title = "Articles"
        navigationController?.navigationBar.isTranslucent = false
    }
   
}

extension ArticlesViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ArticlesCell
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleDetailsViewController = storyboard?.instantiateViewController(identifier: "details") as! ArticleDetailsViewController
        navigationController?.pushViewController(articleDetailsViewController, animated: true)
    }
    
}
