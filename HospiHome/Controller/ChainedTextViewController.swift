//
//  ChainedTextViewController.swift
//  HospiHome
//
//  Created by Elser_10 on 5/4/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class ChainedViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .red
        
        let firstLabel = UILabel()
        firstLabel.textAlignment = .center
//        firstLabel.backgroundColor = .green
        firstLabel.font = UIFont(name: "Farah", size: 34)
        firstLabel.text = "Stay Home"
        
        let secondLabel = UILabel()
        secondLabel.textAlignment = .center
//        secondLabel.backgroundColor = .blue
        secondLabel.font = UIFont(name: "Glyphic Serifs", size: 34)
        secondLabel.text = "Stay Safe"
        
        let stackView = UIStackView(arrangedSubviews: [firstLabel, secondLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate(
        [stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100)]
        )
        
    }
}
