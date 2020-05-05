//
//  ForgotPasswordViewController.swift
//  HospiHome
//
//  Created by Elser_10 on 5/5/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController,KWVerificationCodeViewDelegate {

    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var confirmNewPassword: UITextField!
    @IBOutlet var containerView: UIView!
    var passedMobileNumber: String?
    var verificationCodeView: KWVerificationCodeView?
    
    
    
    func didChangeVerificationCode() {
        let otp = verificationCodeView?.getVerificationCode()
        if let otp = otp{
            
            if(otp.trim().count==6){
                changePassword(withOTP: otp.trim())
        }
        }
    }
    
    
    func changePassword(withOTP: String){
          disableInput()
        let parameters = ["mobile": passedMobileNumber!,"newpassword": newPasswordTextField!.text!,"otp": withOTP]
          
        API().httpPOSTRequest(endpoint: .forgotPassword, postData: parameters) { (data, error) in
               guard let data = data else{self.alertError(withTitle: "Failed to create user", withMessage: "Unknown Response from server, please try again later");return;}
              
                let signupResponse = try? JSONDecoder().decode(APIResponse.self, from: data)
                  if let response = signupResponse{
                    if response.success{
                     DispatchQueue.main.async {
                        self.newPasswordTextField.text! = ""
                        self.confirmNewPassword.text! = ""
                        self.verificationCodeView?.clear()
                        self.dismiss(animated: true, completion: nil)
                        }
                    }
                    else
                    {
                      DispatchQueue.main.async {
                          self.verificationCodeView?.clear()
                      }
                        
                        self.alertError(withTitle: "Failed to change password", withMessage: response.msg)
                        
                    }
                }
              DispatchQueue.main.async {
                   self.disableInput()
              }
          }
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

    
       func setupSpinner() {
           view.addSubview(blackView)
           blackView.addSubview(activityIndicator)
              blackView.alpha = 0
           
           blackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           blackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
           blackView.heightAnchor.constraint(equalToConstant: 120).isActive = true
           blackView.widthAnchor.constraint(equalToConstant: 120).isActive = true
           
           activityIndicator.centerXAnchor.constraint(equalTo: blackView.centerXAnchor).isActive = true
           activityIndicator.centerYAnchor.constraint(equalTo: blackView.centerYAnchor).isActive = true
           activityIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
           activityIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
          
       }
    
    
      func requestOTP(){
          let parameters = ["mobile": passedMobileNumber!]
        API().httpPOSTRequest(endpoint: .otpForgot, postData: parameters as [String : Any]) { (data, error) in
              guard let data = data else{self.alertError(withTitle: "Failed to send OTP", withMessage: "Unknown Response from server, please try again later");return;}
              
              let OTPResponse = try? JSONDecoder().decode(APIResponse.self, from: data)
     
              if let response = OTPResponse{
                  if response.success{
                      self.sendNotification(body: response.msg)
                  }
                  else
                  {
                      self.alertError(withTitle: "Failed to send OTP", withMessage: response.msg)
                      
                  }
              }
          }
      }
    
    func disableInput(){
          if blackView.alpha == 0 {
              blackView.alpha = 1
              activityIndicator.startAnimating()
          }
          else{
              blackView.alpha = 0
              activityIndicator.stopAnimating()
          }
          
        newPasswordTextField?.isEnabled = !newPasswordTextField.isEnabled
          confirmNewPassword.isEnabled = !confirmNewPassword.isEnabled
      }
    
    func alertError(withTitle: String,withMessage: String){
        DispatchQueue.main.async {
        let alert = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
        }
    }

    
    func sendNotification(body: String) {
          let content = UNMutableNotificationContent()
          content.title = "HospiHome"
          content.subtitle = "Your OTP"
          content.body = body
          let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
          let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
          UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.isHidden = true
        verificationCodeView = KWVerificationCodeView(frame: CGRect(x: 0, y: 0, width: 240, height: 60))
        verificationCodeView?.delegate = self
        requestOTP()
        newPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        confirmNewPassword.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        containerView.addSubview(verificationCodeView!)
        
        
    }
@objc func textFieldDidChange(sender: UITextField) {
     containerView.isHidden = true
    if newPasswordTextField.text == confirmNewPassword.text {
        if newPasswordTextField.text!.count < 6 || newPasswordTextField.text!.count > 24{
            newPasswordTextField.text = ""
            confirmNewPassword.text = ""
           alertError(withTitle: "Validation Error", withMessage: "Please enter a valid password between 6-24 characters")
    }
        else{
            containerView.isHidden = false
        }
    }
    }
    
    
}


