//
//  LoginViewController.swift
//  HospiHome
//
//  Created by Elser_10 on 5/1/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField()
    }
    
    func setupTextField() {
        phoneNumberTextField.autocapitalizationType = .sentences
        
        phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: "Enter your phone number", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter your password", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        navigateToHomeVC()
    }
    
    func navigateToHomeVC() {
        
        let tabBarController = storyboard?.instantiateViewController(identifier: "tabBar") as! UITabBarController
        let window = UIApplication.shared.connectedScenes.filter{$0.activationState == .foregroundActive}.map{$0 as? UIWindowScene}.compactMap{$0}.first?.windows.filter{$0.isKeyWindow}.first
        window?.rootViewController = tabBarController
    }
    
    @IBAction func didTapSignUp(_ sender: Any) {
        let registerViewController = storyboard?.instantiateViewController(identifier: "register") as! RegisterViewController
        registerViewController.modalPresentationStyle = .fullScreen
        self.present(registerViewController, animated: false, completion: nil)
    }
}
