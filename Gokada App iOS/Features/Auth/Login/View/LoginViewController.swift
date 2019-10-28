//
//  LoginViewController.swift
//  Gokada App iOS
//
//  Created by Isaac Iniongun on 22/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit
import Repository
import Remote_API
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {
    
    var authViewModel: ILoginViewModel?
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var whiteBackgroundView: UIView!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func getViewModel() -> BaseViewModel {
        return self.authViewModel as! BaseViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePhoneView()
        self.loginView.alpha = 0
        self.whiteBackgroundView.alpha = 0
        animateView()
        configureBinding()
    }
    
    func animateView() {
        UIView.animate(withDuration: 0.6) {
            self.whiteBackgroundView.alpha = 1
            self.loginView.alpha = 1
        }
    }
    
    func configureBinding() {
        authViewModel?.loginResponse.bind { [weak self] res in
            let controller = self?.storyboard?.instantiateViewController(identifier: "otpVC") as! OTPViewController
            controller.loginDetails = res
            self?.navigationController?.pushViewController(controller, animated: true)
        }.disposed(by: disposeBag)
    }
    
    @IBAction func authenticatePhoneNumber(_ sender: UIButton) {
        authViewModel?.sendOTPCode(to: "+234\(phoneNumberField.text!)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func configurePhoneView() {
        self.phoneNumberView.layer.borderWidth = 1
        self.phoneNumberView.layer.borderColor = UIColor.lightGray.cgColor
        self.phoneNumberView.layer.cornerRadius = 5
    }
    
    @IBAction func prepareForUnwind(_ segue: UIStoryboardSegue) { }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 10
    }
}
