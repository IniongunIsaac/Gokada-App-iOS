//
//  WelcomeViewController.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 23/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit
import Lottie

class WelcomeViewController: BaseViewController {

    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var continueView: UIView!
    @IBOutlet weak var continueViewAnimationView: AnimationView!
    @IBOutlet weak var whiteOverlayView: UIView!
    var welcomeViewModel: IWelcomeViewModel?
    
    override func getViewModel() -> BaseViewModel {
        return welcomeViewModel as! BaseViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
        
        setupViews()
        startAnimation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupViews() {
        continueView.alpha = 0
        whiteOverlayView.alpha = 0
    }
    
    @IBAction func showLoginPage(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            UIView.animate(withDuration: 0.6) {
                self.continueView.alpha = 0
                self.whiteOverlayView.alpha = 1
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.performSegue(withIdentifier: "showAuthSegue", sender: self)
        }
        continueViewAnimationView.play()
    }
    
    func startAnimation() {
        animationView.animation = Animation.named("gokada_splash_amin")
        animationView.play { [weak self] (_) in
            if (self?.welcomeViewModel?.userLoggedIn())! {
                self?.showDashboard()
            } else {
                self?.showContinueView()
            }
        }
    }
    
    func showDashboard() {
//        let storyboard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "homeVC")
//        self.show(vc, sender: self)
//        self.navigationItem.setHidesBackButton(true, animated:true)
//        performSegue(withIdentifier: "showProfile", sender: nil)
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileDetailsViewController")
        self.navigationController?.setViewControllers([vc], animated: true)
    }
    
    func showContinueView() {
        UIView.animate(withDuration: 0.4) {
            self.continueView.alpha = 1
            self.continueViewAnimationView.animation = Animation.named("gokada_welcome_anim")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

}

extension UIViewController: UINavigationControllerDelegate {
    public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return .portrait
    }
}
