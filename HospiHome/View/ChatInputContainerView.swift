//
//  ChatInputContainerView.swift
//  HospiHome
//
//  Created by Elser_10 on 4/30/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class ChatInputContainerView: UIView, UITextViewDelegate {
    
    var chatController: ChatViewController? {
        didSet {
            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: chatController, action: #selector(chatController?.handlePickerTap)))
        }
    }
    
    lazy var inputTextView: MessageInputTextView = {
        let tv = MessageInputTextView()
        tv.placeHolderLabel.text = "Type a message..."
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        tv.layer.cornerRadius = 16
        tv.layer.masksToBounds = true
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        tv.contentInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        return tv
    }()
    
    lazy var uploadImageView: UIImageView = {
        let uploadImageView = UIImageView()
        uploadImageView.image = UIImage(named:"upload_image_icon")
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        return uploadImageView
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.setImage(UIImage(named: "send")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .gray
        button.addTarget(chatController, action: #selector(handleSendButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleSendButton() {
        chatController?.handleSend()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        
        backgroundColor = .white
        
        // upload imageView
        addSubview(uploadImageView)
        
        uploadImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        // input text view
        addSubview(inputTextView)
        
        inputTextView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        inputTextView.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        inputTextView.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        // seperator line
        let seperatorLine = UIView()
        seperatorLine.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        seperatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(seperatorLine)
        seperatorLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        seperatorLine.topAnchor.constraint(equalTo: topAnchor).isActive = true
        seperatorLine.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        seperatorLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            sendButton.imageView?.tintColor = .gray
            sendButton.isEnabled = false
        } else {
            sendButton.imageView?.tintColor = UIColor(r: 61, g: 154, b: 255)
            sendButton.isEnabled = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func didTapSend(_ sender: Any) {
        print("sssss")
    }
}
