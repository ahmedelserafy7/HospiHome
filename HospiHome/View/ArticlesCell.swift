//
//  ArticlesCell.swift
//  HospiHome
//
//  Created by Elser_10 on 5/1/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class ArticlesCell: UITableViewCell {
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var articleTimeLabel: UILabel!
    override func awakeFromNib() {
        setupViews()
    }
    
    func setupViews() {
        gradientView.backgroundColor = UIColor(white: 0, alpha: 0.45)
        articleTimeLabel.layer.borderColor = UIColor.white.cgColor
        articleTimeLabel.layer.borderWidth = 1
        articleTimeLabel.layer.cornerRadius = 4
        articleTimeLabel.layer.masksToBounds = true
    }
}
