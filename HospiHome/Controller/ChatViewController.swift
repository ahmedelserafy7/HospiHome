//
//  ChatViewController.swift
//  HospiHome
//
//  Created by Elser_10 on 4/30/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    fileprivate let cellId = "cellId"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    var messages = [Message(text: "Hey mr toumbrine man, play a song for me, and there is no place i'm going to"), Message(text: "Hey mr toumbrine man, play a song for me")]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: cellId)
        setupViews()
        
        // dismiss keyboard
        collectionView.keyboardDismissMode = .interactive
    }
    
    func setupViews() {
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
        collectionView.topAnchor.constraint(equalTo: view.topAnchor),
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupNavBar() {
        
        // right bar button
        let videoImage = UIImage(systemName: "video.fill")
        let rightButtonItem = UIBarButtonItem(image: videoImage, style: .plain, target: self, action: #selector(handleVideo))
        rightButtonItem.tintColor = .red
        navigationItem.rightBarButtonItem = rightButtonItem
        
        handleNavigationTitle()
    }
    
    func handleNavigationTitle() {
       let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        titleView.backgroundColor = .red
        
        let profileImageView = UIImageView(image: #imageLiteral(resourceName: "elon"))
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        
        titleView.addSubview(profileImageView)
        
        profileImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: titleView.leftAnchor, constant: 8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Ahmed Samir Elserafy"
        
        titleView.addSubview(nameLabel)
        
        nameLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        navigationItem.titleView = titleView
    }
    
    @objc func handleVideo() {
        
    }
    
    lazy var messageContainerView: ChatInputContainerView = {
      
        let chatInputContainerView = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        chatInputContainerView.chatController = self
        return chatInputContainerView
    }()
    
    // show keyboard
    override var inputAccessoryView: UIView? {
        get {
            return messageContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func handlePickerTap() {
        let pickerController = UIImagePickerController()
        pickerController.modalPresentationStyle = .fullScreen
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        handleSelectedImageWithInfo(info: info)
        
        dismiss(animated: true, completion: nil)
    }
    
    func handleSelectedImageWithInfo(info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] {
            print(originalImage)
        } else if let editedImage = info[UIImagePickerController.InfoKey.editedImage] {
            print("edited Image\(editedImage)")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSend() {
        print("you send \(messageContainerView.inputTextView.text)")
        let message = Message(text: messageContainerView.inputTextView.text)
        messages.append(message)
        self.collectionView.reloadData()
        clearText()
    }
    
    func clearText() {
        messageContainerView.inputTextView.text = nil
        messageContainerView.inputTextView.placeHolderLabel.isHidden = false
        messageContainerView.sendButton.imageView?.tintColor = .gray
        messageContainerView.sendButton.isEnabled = false
        messageContainerView.inputTextView.resignFirstResponder()
    }
    
}

extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatCell
        
        let message = messages[indexPath.item]
        guard let messageText = message.text else { return ChatCell()}
        
        cell.textView.text = messageText
        
        cell.bubbleViewWidthAnchor?.constant = estimatedSizeOfTextFrame(messageText).width + 24
        
        setupCell(message, cell)
        return cell
    }
    
    func setupCell(_ message: Message, _ cell: ChatCell) {
        // outgoing messages
        
//        cell.bubbleView.backgroundColor = UIColor(r: 0, g: 137, b: 249)
        let blueBubbleImageView = UIImage(named: "bubble_blue")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22,left: 26,bottom: 22,right: 26)).withRenderingMode(.alwaysTemplate)
        
        cell.bubbleImageView.image = blueBubbleImageView
        cell.bubbleImageView.tintColor = UIColor(r: 0, g: 137, b: 249)
        
        cell.textView.textColor = .white
        
        cell.bubbleViewLeftAnchor?.isActive = false
        cell.bubbleViewRightAnchor?.isActive = true
        
        // incoming gray messages
        
//        cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
        
       /* let grayBubbleImageView = UIImage(named: "bubble_gray")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22,left: 26,bottom: 22,right: 26)).withRenderingMode(.alwaysTemplate)
        
        cell.bubbleImageView.image = grayBubbleImageView
        cell.bubbleImageView.tintColor = UIColor(r: 240, g: 240, b: 240)
        
        cell.textView.textColor = .black

        cell.bubbleViewLeftAnchor?.isActive = true
        cell.bubbleViewRightAnchor?.isActive = false*/
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat?
        let message = messages[indexPath.item]
        if let text = message.text {
            height = estimatedSizeOfTextFrame(text).height + 20
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height!)
    }
    
    fileprivate func estimatedSizeOfTextFrame(_ addText: String)-> CGRect {
        
        let size = CGSize(width: 200, height: 1000)
        
        return NSString(string: addText).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
}
