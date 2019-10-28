//
//  OTPViewController.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 24/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit
import Entities

class OTPViewController: BaseViewController {

    @IBOutlet weak var otpCodeField: UITextField!
    var otpViewModel: IOTPViewModel?
    var loginDetails: PhoneNumberAuth!
    @IBOutlet weak var countdownLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var resendBtn: UIButton!
    
    
    override func getViewModel() -> BaseViewModel {
        return self.otpViewModel as! BaseViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        otpCodeField.defaultTextAttributes.updateValue(29.0, forKey: .kern)
        configureBinding()
        otpViewModel?.startCountdown(from: self.loginDetails.timeToLive)
        
        var hiddenPhoneNumber = self.loginDetails.phoneNumber
        let startInd = hiddenPhoneNumber.index(hiddenPhoneNumber.startIndex, offsetBy: 7)
        let endInd = hiddenPhoneNumber.index(hiddenPhoneNumber.startIndex, offsetBy: 10)
        
        hiddenPhoneNumber.replaceSubrange(startInd..<endInd, with: " *** ")
        
        phoneLbl.text = "Kindly Check Your Phone (\(hiddenPhoneNumber)) for your OTP"
        resendBtn.setTitleColor(.darkText, for: .disabled)
    }
    
    func configureBinding() {
        otpViewModel?.otpResponse.bind { [weak self] res in
            self?.otpViewModel?.stopCountdown()
            
            if res.user.firstName != nil {
                self?.performSegue(withIdentifier: "showWelcomeSegue", sender: self)
            } else {
                let controller = self?.storyboard?.instantiateViewController(identifier: "registrationVC") as! RegisterViewController
                controller.currentUser = res.user
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        }.disposed(by: disposeBag)
        
        otpViewModel?.countDownTime.bind { [weak self] res in
            guard (Int(res) ?? 0 > 0) else {
                self?.resendBtn.isEnabled = true
                self?.countdownLbl.text = "00:00 Min"
                return
            }
            self?.resendBtn.isEnabled = false
            self?.countdownLbl.text = "00:\(res) Min"
        }.disposed(by: disposeBag)
        
        otpViewModel?.resendOTPResponse.bind { [weak self] res in
            self?.otpViewModel?.startCountdown(from: res.timeToLive)
        }.disposed(by: disposeBag)
    }
    
    @IBAction func callWithOTPCode(_ sender: UIButton) {
        otpViewModel?.resendOTP(to: loginDetails.phoneNumber, type: .voice)
    }
    
    @IBAction func resendOTPCode(_ sender: UIButton) {
        otpViewModel?.resendOTP(to: loginDetails.phoneNumber, type: .sms)
    }
    
    @IBAction func verifyOTP(_ sender: UIButton) {
        otpViewModel?.verifyOTPCode(code: self.otpCodeField.text!, phone: loginDetails.phoneNumber)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension OTPViewController {
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

extension OTPViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 5
    }
}
