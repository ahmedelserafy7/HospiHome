//
//  ProfileViewController.swift
//  HospiHome
//
//  Created by Elser_10 on 4/30/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var mobileNumberLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    
    enum CardState {
        case collapsed
        case expanded
    }
    
    var cardVisible = false
    var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    let cardHeight: CGFloat = 600
    let areaHeight: CGFloat = 70
    var cardViewController: CardViewController!
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgress: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = profile?.name
        emailLabel.text = profile?.email
        mobileNumberLabel.text = profile?.mobile
        view.backgroundColor = UIColor(r: 244, g: 246, b: 245)
        navigationItem.title = "Profile"
        fetchUserAvatar()
        
        setupCard()
    }
    
    
    func fetchUserAvatar(){
        let parameters = ["userid": profile!.id]
        
        API().httpPOSTRequest(endpoint: .avatar, postData: parameters) { (data, error) in
            guard let data = data else{return;}
            
            if let avatarResponse = try? JSONDecoder().decode(AvatarResponse.self, from: data){
                if avatarResponse.avatarBase64.count>50{
                    profile?.avatar = Data(base64Encoded: avatarResponse.avatarBase64.replacingOccurrences(of: "\\/", with: "/"))
                    if let av = profile?.avatar{  
                        DispatchQueue.main.async{self.avatarImageView.image = UIImage(data: av)}
                    }
                }
                
            }

        }
    }
    
    func logout(){
        API().httpGETRequest(endpoint: .logout) { (data, error) in  }
        navigateToLoginVC()
    }
    
    func navigateToLoginVC() {
        DispatchQueue.main.async {
            let loginViewController = self.storyboard?.instantiateViewController(identifier: "login") as! LoginViewController
        loginViewController.modalPresentationStyle = .fullScreen
        self.present(loginViewController, animated: true, completion: nil)
        }
    }
    
    
    var visualEffectView = UIVisualEffectView()
    func setupCard() {
        
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        
         cardViewController = CardViewController(nibName: "CardViewController", bundle: nil)
        addChild(cardViewController)
        view.addSubview(cardViewController.view)
        
        cardViewController.view.frame = CGRect(x: 20, y: view.frame.height - areaHeight - 60, width: view.bounds.width - 40, height: cardHeight)
        
        cardViewController.view.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recognizer:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        
        cardViewController.moveAreaView.addGestureRecognizer(tapGesture)
        cardViewController.moveAreaView.addGestureRecognizer(panGesture)
    }
    
    @objc func handleCardTap(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            animateTransition(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    @objc func handleCardPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: cardViewController.moveAreaView)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransition(state: state, duration: duration)
        }
        
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgress = animator.fractionComplete
        }
    }
    
    func animateTransition(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                    case .collapsed: self.cardViewController.view.frame.origin.y = self.view.frame.height - self.areaHeight - 60
                    case .expanded: self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            let cornerRadiusPropertyAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .collapsed:
                    self.cardViewController.view.layer.cornerRadius = 0
                case .expanded:
                    self.cardViewController.view.layer.cornerRadius = 12
                }
            }
            
            cornerRadiusPropertyAnimator.startAnimation()
            runningAnimations.append(cornerRadiusPropertyAnimator)
        }
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = animationProgress + fractionCompleted
        }
    }
    
    func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
}







