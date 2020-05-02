//
//  ProfileCell.swift
//  HospiHome
//
//  Created by Elser_10 on 5/2/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    let imageName: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        
        addSubview(imageName)
        
        imageName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageName.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        imageName.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageName.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: imageName.rightAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
