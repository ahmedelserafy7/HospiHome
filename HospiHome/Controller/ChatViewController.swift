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
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var chatInputContainerView: ChatInputContainerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        // dismiss keyboard
        tableView.keyboardDismissMode = .interactive
    }
    
    func setupNavBar() {
        
        // change back button item title
        let backItem = UIBarButtonItem()
        backItem.title = " Ahmed Samir"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
        
        // right bar button
        let videoImage = UIImage(systemName: "video.fill")
        let rightButtonItem = UIBarButtonItem(image: videoImage, style: .plain, target: self, action: #selector(handleVideo))
        rightButtonItem.tintColor = .red
        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    @objc func handleVideo() {
        
    }
    
    lazy var messageContainerView: ChatInputContainerView = {
        
        let chatInputContainerView = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
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
        print("Send")
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageCell
        return cell
    }
}
