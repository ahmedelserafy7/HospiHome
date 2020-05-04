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
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestNotificationsPermissions()
        setupTextField()
    }
    
    func requestNotificationsPermissions(){
     UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
          (granted, error) in
      }
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
        validateInputFieldsAndLogin()
    }
    
    func validateInputFieldsAndLogin(){
        if phoneNumberTextField.text!.count < 10 || phoneNumberTextField.text!.count > 15{
            alertError(withMessage: "Please enter a valid mobile number")
            return
        }
        if passwordTextField.text!.count < 6 || passwordTextField.text!.count > 24{
            alertError(withMessage: "Please enter a valid password between 6-24 characters")
            return
        }
        login()
    }
    
    func disableInput(){
         DispatchQueue.main.async {
            self.phoneNumberTextField.isEnabled = !self.phoneNumberTextField.isEnabled
            self.passwordTextField.isEnabled = !self.passwordTextField.isEnabled
            self.loginButton.isEnabled = !self.loginButton.isEnabled
        }
    }
    
    func login(){
        disableInput()
        let parameters = ["mobile": "+2"+phoneNumberTextField.text!, "password":passwordTextField.text!]
        API().httpPOSTRequest(endpoint: .login, postData: parameters) { (data, error) in
            guard let data = data else{self.alertError(withMessage: "Unknown Response from server, please try again later");self.disableInput();return;}
            let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data)
  
              if let response = loginResponse{
                  if response.success{
                    access_token = response.access_token!
                    profile = response.profile!
                    DispatchQueue.main.async {self.navigateToHomeVC()}
                  }
                  else
                  {
                      self.alertError(withMessage: response.msg!)
                      
                  }
              }
              else{
                self.alertError(withMessage: "Unknown Response from server, please try again later");
                self.disableInput();
                return;
            }
           
                 self.disableInput()
            
           
        }
    }
    
    func navigateToHomeVC() {
        
        let tabBarController = storyboard?.instantiateViewController(identifier: "tabBar") as! UITabBarController
        let window = UIApplication.shared.connectedScenes.filter{$0.activationState == .foregroundActive}.map{$0 as? UIWindowScene}.compactMap{$0}.first?.windows.filter{$0.isKeyWindow}.first
        window?.rootViewController = tabBarController
    }
    
    @IBAction func didTapSignUp(_ sender: Any) {
         if phoneNumberTextField.text!.count<10{
                  alertError(withMessage: "Please enter your mobile number to register")
                  return
              }
              
              let registerViewController = storyboard?.instantiateViewController(identifier: "register") as! RegisterViewController
              registerViewController.passedMobileNumber = "+2"+phoneNumberTextField.text!
              registerViewController.modalPresentationStyle = .fullScreen
              self.present(registerViewController, animated: false, completion: nil)
    }
    
    func alertError(withMessage: String){
        DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: withMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }

    }
}
