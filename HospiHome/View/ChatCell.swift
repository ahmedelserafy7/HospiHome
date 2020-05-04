//
//  MessageCell.swift
//  HospiHome
//
//  Created by Elser_10 on 4/30/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class ChatCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = .clear
        tv.isUserInteractionEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let bubbleView: UIView = {
        let bv = UIView()
        bv.layer.cornerRadius = 14
        bv.layer.masksToBounds = true
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()
    
    let bubbleImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewWidthAnchor: NSLayoutConstraint?
    func setupViews() {
        
        // bubble view constraints
        addSubview(bubbleView)
        bubbleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)
        bubbleViewLeftAnchor?.isActive = false
        bubbleViewWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleViewWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        // bubble imageView
        bubbleView.addSubview(bubbleImageView)
        NSLayoutConstraint.activate([
        bubbleImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor),
        bubbleImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor),
        bubbleImageView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor),
        bubbleImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor)
        ])
        
        
        // text view constraints
        bubbleImageView.addSubview(textView)
        textView.leftAnchor.constraint(equalTo: bubbleImageView.leftAnchor,constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleImageView.rightAnchor, constant: -8).isActive = true
        textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
