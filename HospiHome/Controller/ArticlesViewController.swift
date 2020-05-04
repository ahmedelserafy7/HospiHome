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
    var articlesArray = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArticles()
        navigationItem.title = "Articles"
        navigationController?.navigationBar.isTranslucent = false
    }
   
    func fetchArticles(){
        API().httpGETRequest(endpoint: .fetchArticles) { (data, error) in
            
            guard let data = data else{self.alertError(withMessage: "Unknown Response from server, please try again later");return;}
            
            guard var articles = try? JSONDecoder().decode(ArticlesResponse.self, from: data).articles else{self.alertError(withMessage: "Unknown Response from server, please try again later");return;}
            
            for i in 0..<articles.count{
                articles[i].shortDate = articles[i].shortDate.replacingOccurrences(of: " ", with: "\n")
                articles[i].body = articles[i].body.replacingOccurrences(of: "\\n", with: "\n")
                let base64String = articles[i].poster
                if base64String.count>50{
                    articles[i].posterImage = Data(base64Encoded: base64String.replacingOccurrences(of: "\\/", with: "/"))
                    self.articlesArray.append(articles[i])
                }
                }
            DispatchQueue.main.async {
                 self.tableView.reloadData()
            }
               
        }
    }

    
    func alertError(withMessage: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error Fetching Articles", message: withMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
}





extension ArticlesViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ArticlesCell
        cell.articleTimeLabel.text = articlesArray[indexPath.row].shortDate
        cell.body.text = articlesArray[indexPath.row].body
        cell.title.text = articlesArray[indexPath.row].title
        if let posterImage = articlesArray[indexPath.row].posterImage{
        cell.posterImageView.image = UIImage(data: posterImage)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleDetailsViewController = storyboard?.instantiateViewController(identifier: "details") as! ArticleDetailsViewController
        articleDetailsViewController.article = articlesArray[indexPath.row]
        navigationController?.pushViewController(articleDetailsViewController, animated: true)
      
    }
    
}
