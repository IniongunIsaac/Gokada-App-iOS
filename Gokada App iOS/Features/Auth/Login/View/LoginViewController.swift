//
//  LoginViewController.swift
//  Gokada App iOS
//
//  Created by Isaac Iniongun on 22/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    var authViewModel: IAuthViewModel?
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var whiteBackgroundView: UIView!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get{
            return .portrait
        }
    }
    
    override func getViewModel() -> BaseViewModel {
        return self.authViewModel as! BaseViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePhoneView()
        self.loginView.alpha = 0
        self.whiteBackgroundView.alpha = 0
        animateView()
    }
    
    func animateView() {
        UIView.animate(withDuration: 0.6) {
            self.whiteBackgroundView.alpha = 1
            self.loginView.alpha = 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func configurePhoneView() {
        self.phoneNumberView.layer.borderWidth = 1
        self.phoneNumberView.layer.borderColor = UIColor.lightGray.cgColor
        self.phoneNumberView.layer.cornerRadius = 5
    }
}
