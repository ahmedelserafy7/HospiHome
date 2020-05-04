//
//  OTPViewController.swift
//  HospiHome
//
//  Created by Seif Elmenabawy on 5/3/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController,KWVerificationCodeViewDelegate {
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dismissButton: UIButton!
    
    var mobileNumber: String?
    
    func didChangeVerificationCode() {
        let otp = verificationCodeView?.getVerificationCode()
        if let otp = otp{
            
            if(otp.trim().count==6){
                registerAccount(withOTP: otp.trim())
        }
        }
    }
    
    
    func requestOTP(){
        let parameters = ["mobile": mobileNumber!]
        API().httpPOSTRequest(endpoint: .otp, postData: parameters as [String : Any]) { (data, error) in
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
    

    func registerAccount(withOTP: String){
        disableInput()
        let registerView = self.presentingViewController as! RegisterViewController
        let name = registerView.nameTextField.text!
        let password = registerView.passwordTextField.text!
        let email = registerView.emailTextField.text!.trim()
    
        let parameters = ["name": name,"email": email,"password": password,"mobile": mobileNumber!,"otp": withOTP]
        
        API().httpPOSTRequest(endpoint: .signup, postData: parameters) { (data, error) in
             guard let data = data else{self.alertError(withTitle: "Failed to create user", withMessage: "Unknown Response from server, please try again later");return;}
            
              let signupResponse = try? JSONDecoder().decode(APIResponse.self, from: data)
                if let response = signupResponse{
                  if response.success{
                    self.navigateToLoginVC()
                  }
                  else
                  {
                    DispatchQueue.main.async {
                        self.verificationCodeView?.clear()
                    }
                      
                      self.alertError(withTitle: "Failed to create user", withMessage: response.msg)
                      
                  }
              }
            DispatchQueue.main.async {
                 self.disableInput()
            }
        }
    }
    
    func disableInput(){
        // spinner
        verificationCodeView?.isUserInteractionEnabled = !verificationCodeView!.isUserInteractionEnabled
        dismissButton.isEnabled = !dismissButton.isEnabled
    }

    func navigateToLoginVC() {
        DispatchQueue.main.async {
            let loginViewController = self.storyboard?.instantiateViewController(identifier: "login") as! LoginViewController
        loginViewController.modalPresentationStyle = .fullScreen
        self.present(loginViewController, animated: true, completion: nil)
        }
    }

  // MARK: - Variables
  var verificationCodeView: KWVerificationCodeView?
    
    
    // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    verificationCodeView = KWVerificationCodeView(frame: CGRect(x: 0, y: 0, width: 240, height: 60))
    verificationCodeView?.delegate = self
    
    containerView.addSubview(verificationCodeView!)
  }

  @IBAction func submitButtonTapped(_ sender: Any) {
    if verificationCodeView!.hasValidCode() {
      let alertController = UIAlertController(title: "Success", message: "Code is \(verificationCodeView!.getVerificationCode())", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
      alertController.addAction(okAction)
      present(alertController, animated: true, completion: nil)
    }
  }

  @IBAction func dismissButtonTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
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
    
    func alertError(withTitle: String,withMessage: String){
        DispatchQueue.main.async {
        let alert = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
        }
    }
}
