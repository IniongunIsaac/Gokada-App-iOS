//
//  AuthViewController.swift
//  Gokada App iOS
//
//  Created by Isaac Iniongun on 22/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit
import Lottie

class AuthViewController: UIViewController {
    
    var authViewModel: IAuthViewModel?
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var continueView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var continueViewAnimationView: AnimationView!
    @IBOutlet weak var whiteOverlayView: UIView!
    @IBOutlet weak var phoneNumberView: UIView!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get{
            return .portrait
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        startAnimation()
    }
    
    func setupViews() {
        continueView.alpha = 0
        loginView.alpha = 0
        whiteOverlayView.alpha = 0
        configurePhoneView()
    }
    
    func configurePhoneView() {
        self.phoneNumberView.layer.borderWidth = 1
        self.phoneNumberView.layer.borderColor = UIColor.lightGray.cgColor
        self.phoneNumberView.layer.cornerRadius = 5
    }
    
    @IBAction func showLoginPage(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            UIView.animate(withDuration: 0.6) {
                self.continueView.alpha = 0
                self.whiteOverlayView.alpha = 1
                self.loginView.alpha = 1
            }
        })
        continueViewAnimationView.play()
    }
    
    func startAnimation() {
        animationView.animation = Animation.named("gokada_splash_amin")
        animationView.play { (_) in
            self.showContinueView()
        }
    }
    
    func showContinueView() {
        UIView.animate(withDuration: 0.4) {
            self.continueView.alpha = 1
            self.continueViewAnimationView.animation = Animation.named("gokada_welcome_anim")
        }
    }

}
