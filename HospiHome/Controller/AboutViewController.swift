//
//  AboutViewController.swift
//  HospiHome
//
//  Created by Elser_10 on 5/5/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    let dialogueLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupViews()
        
        let displayLink = CADisplayLink(target: self, selector: #selector(updateText))
        displayLink.add(to: .main, forMode: .default)
    }
    
    func setupNavBar() {
        navigationItem.title = "About"
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setupViews() {
        view.addSubview(dialogueLabel)
        
        dialogueLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        dialogueLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        dialogueLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:
        50).isActive = true
    }
    
    var myCounter = 0
    @objc func updateText() {
       
        let textString = "Created by Ahmed Elserafy, and Seif Hatem."
        
        // to organize showing characters indvidually in text
        let textArray = Array(textString)
        
       if myCounter == textArray.count {
           self.dialogueLabel.text = "Created by Ahmed Elserafy, and Seif Hatem."
       } else {
//           self.dialogueLabel.text = dialogueLabel.text! + String(textArray[myCounter])
           self.dialogueLabel.text?.append(textArray[myCounter])
           
           myCounter += 1
       }
    }
    
}
