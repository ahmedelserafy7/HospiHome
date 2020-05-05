//
//  MessageInputTextView.swift
//  HospiHome
//
//  Created by Elser_10 on 5/3/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class MessageInputTextView: UITextView {
    
    let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(white: 0.4, alpha: 0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc func handleTextChange() {
        placeHolderLabel.isHidden = !text.isEmpty
    }
    
    func setupViews() {
        addSubview(placeHolderLabel)
        placeHolderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        placeHolderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        placeHolderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        placeHolderLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
