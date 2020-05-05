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
    
    var passedMobileNumber: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        handleKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        blackView.isHidden = true
        super.viewWillAppear(animated)
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
    
    let blackView: UIView = {
        let bv = UIView()
        bv.backgroundColor = .black
        bv.layer.cornerRadius = 16
        bv.layer.masksToBounds = true
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let aI = UIActivityIndicatorView(style: .white)
        aI.hidesWhenStopped = true
        aI.translatesAutoresizingMaskIntoConstraints = false
        return aI
    }()
    
    @IBAction func didTapRegister(_ sender: Any) {
         validateInputFields()
        //won't run as another UIAlert is intact
        askForPhoneNumber()
    }
    
    func setupAuthorizing() {
        
        view.addSubview(blackView)
        blackView.addSubview(activityIndicator)
        
        blackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        blackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        blackView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        blackView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: blackView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: blackView.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func validateInputFields(){
        
        setupAuthorizing()
        self.blackView.alpha = 1
        self.activityIndicator.startAnimating()
        
        if nameTextField.text!.count < 6 || nameTextField.text!.count > 50{
            alertError(withMessage: "Please enter a valid name")
            return
        }
        if emailTextField.text!.trim().count < 5 || emailTextField.text!.trim().count > 50 || !emailTextField.text!.trim().contains("@"){
            alertError(withMessage: "Please enter a valid email")
            return
        }
        if passwordTextField.text!.count < 6 || emailTextField.text!.count > 24{
            alertError(withMessage: "Password must be 6-24 characters")
            return
        }
        if passwordTextField.text! != confirmPasswordTextField.text!{
            alertError(withMessage: "Both passwords should be the same")
            return
        }
    }
    
    func askForPhoneNumber(){
           let alert = UIAlertController(title: "SMS Verification", message: "Please conifrm your mobile number", preferredStyle: .alert)

           alert.addTextField { (textField) in
               textField.text = self.passedMobileNumber
           }

           alert.addAction(UIAlertAction(title: "That's Correct", style: .default, handler: { [weak alert] (_) in
               let textField = alert?.textFields![0]
               self.showOTPView(withPhoneNumber: textField!.text!)
           }))
           self.present(alert, animated: true, completion: nil)
       }
       
    func showOTPView(withPhoneNumber: String) {
        let OTPView = self.storyboard?.instantiateViewController(identifier: "otp") as! OTPViewController
        OTPView.modalPresentationStyle = .fullScreen
        self.present(OTPView, animated: true, completion: nil)
        OTPView.titleLabel.text = "SMS sent to " + withPhoneNumber
        OTPView.mobileNumber = withPhoneNumber
        OTPView.requestOTP()
        
    }
    
    func alertError(withMessage: String){
        let alert = UIAlertController(title: "Error", message: withMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true) {
            self.blackView.alpha = 0
            self.activityIndicator.stopAnimating()
        }
//        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
