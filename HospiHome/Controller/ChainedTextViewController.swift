//
//  ChainedTextViewController.swift
//  HospiHome
//
//  Created by Elser_10 on 5/4/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class ChainedViewController: UIViewController {
    
    let logoImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "logo"))
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let firstLabel = UILabel()
    let secondLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLogoImage()
        setupStackView()
        setupLabels()

        srtupAnimations()
    }
    
    func setupLogoImage() {
        view.addSubview(logoImageView)
        
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 160).isActive = true
    }
    
    func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [firstLabel, secondLabel])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate(
            [stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60),
             stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100)]
        )
    }
    
    func setupLabels() {
        firstLabel.text = "Stay Home"
        firstLabel.textAlignment = .center
        firstLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        
        secondLabel.text = "Stay Safe"
        secondLabel.textAlignment = .center
       // secondLabel.font = UIFont(name: "Glyphic Serifs", size: 34)
    }
    
    fileprivate func srtupAnimations() {
        // setup animations
        secondLabel.font = UIFont(name: "Glyphic Serifs", size: 28)
        self.firstLabel.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.7)
        UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.firstLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                
                self.firstLabel.layer.transform = CATransform3DMakeScale(0.13, 0.13, 0.13)
                
            }, completion: { (_) in
                self.firstLabel.alpha = 0
                self.firstLabel.removeFromSuperview()
                
                UIView.animate(withDuration: 0.5, delay: 2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    self.secondLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
                }) { _ in
                    //
                    self.delay(1.5) {
                        let loginViewController = self.storyboard?.instantiateViewController(identifier: "login") as! LoginViewController
                        loginViewController.modalPresentationStyle = .fullScreen
                        self.present(loginViewController, animated: false, completion: nil)
                    }
                    
                }
            })
        }
    }
    
    func delay(_ delay: Double, closure: @escaping()->()) {
        let time = DispatchTime.now() + ((delay * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC))
        DispatchQueue.main.asyncAfter(deadline: time, execute: closure)
    }
}
