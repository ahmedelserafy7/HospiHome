//
//  RegisterViewController.swift
//  HospiHome
//
//  Created by Elser_10 on 5/1/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        handleKeyboard()
    }
    
    func setupTextField() {
        nameTextField.autocapitalizationType = .sentences
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Enter your full name", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "name@address.com", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter your password", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Enter confirm password", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
    }
    
    func handleKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardShowing), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardHiding), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func KeyboardShowing() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -110, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    @objc func KeyboardHiding() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func didTapRegister(_ sender: Any) {
        navigateToHomeVC()
    }
    
    func navigateToHomeVC() {
        
        let tabBarController = storyboard?.instantiateViewController(identifier: "tabBar") as! UITabBarController
        let window = UIApplication.shared.connectedScenes.filter{$0.activationState == .foregroundActive}.map{$0 as? UIWindowScene}.compactMap{$0}.first?.windows.filter{$0.isKeyWindow}.first
        window?.rootViewController = tabBarController
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
