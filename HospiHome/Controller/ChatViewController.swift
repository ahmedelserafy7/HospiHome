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
    var timer = Timer()
    var messages = [Message]()
    var recipientContact: Contact?
    var index: Int?
    
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
    
    @objc func fetchMessages(){
        let parameters = ["recipient": recipientContact!.id]
        API().httpPOSTRequest(endpoint: .fetchMessages, postData: parameters) { (data, error) in
            if let data = data{
                if let response = try? JSONDecoder().decode(FetchMessagesResponse.self, from: data){
                    self.messages = response.messages
                    DispatchQueue.main.async{
                        self.collectionView.reloadData()
                    }
                }
            }
            
        }
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.fetchMessages), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
        super.viewDidDisappear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scheduledTimerWithTimeInterval()
        super.viewDidAppear(animated)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMessages()
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
        //        let videoImage = UIImage(systemName: "video.fill")
        //        let rightButtonItem = UIBarButtonItem(image: videoImage, style: .plain, target: self, action: #selector(handleVideo))
        //        rightButtonItem.tintColor = .red
        //        navigationItem.rightBarButtonItem = rightButtonItem
        
        handleNavigationTitle()
    }
    
    func handleNavigationTitle() {
        navigationItem.title = recipientContact!.name
       /* let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        titleView.backgroundColor = .red
        
        let profileImageView = UIImageView(image: #imageLiteral(resourceName: "dr_profile_img"))
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
        nameLabel.text = recipientContact!.name
        
        titleView.addSubview(nameLabel)
        
        nameLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        //nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        navigationItem.titleView = titleView*/
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
        //print("you send \(messageContainerView.inputTextView.text)")
        
        let message = Message(body: messageContainerView.inputTextView.text, from_id: profile!.id, to_id: recipientContact!.id)
        messages.append(message)
        chatContacts[index!].lastmessage = message.body
        let parameters = ["recipient":recipientContact!.id, "body":message.body] as! [String:String]
        API().httpPOSTRequest(endpoint: .sendMessage, postData: parameters) { (data, error) in
            if let data = data{
                if let response = try? JSONDecoder().decode(FetchMessagesResponse.self, from: data){
                    self.messages = response.messages
                    DispatchQueue.main.async{
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
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
        let messageText = message.body
        
        cell.textView.text = messageText
        
        cell.bubbleViewWidthAnchor?.constant = estimatedSizeOfTextFrame(messageText).width + 24
        
        setupCell(message, cell)
        return cell
    }
    
    func setupCell(_ message: Message, _ cell: ChatCell) {
        // outgoing messages
        
        if (message.from_id==profile!.id){
            
            let blueBubbleImageView = UIImage(named: "bubble_blue")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22,left: 26,bottom: 22,right: 26)).withRenderingMode(.alwaysTemplate)
            
            cell.bubbleImageView.image = blueBubbleImageView
            cell.bubbleImageView.tintColor = UIColor(r: 0, g: 137, b: 249)
            
            cell.textView.textColor = .white
            
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.bubbleViewRightAnchor?.isActive = true
        } else {
            // incoming gray messages
            
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            
            let grayBubbleImageView = UIImage(named: "bubble_gray")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22,left: 26,bottom: 22,right: 26)).withRenderingMode(.alwaysTemplate)
            
            cell.bubbleImageView.image = grayBubbleImageView
            cell.bubbleImageView.tintColor = UIColor(r: 240, g: 240, b: 240)
            
            cell.textView.textColor = .black
            
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.bubbleViewRightAnchor?.isActive = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat?
        let message = messages[indexPath.item]
        let text = message.body
        height = estimatedSizeOfTextFrame(text).height + 20
        
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height!)
    }
    
    fileprivate func estimatedSizeOfTextFrame(_ addText: String)-> CGRect {
        
        let size = CGSize(width: 200, height: 1000)
        
        return NSString(string: addText).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
}
