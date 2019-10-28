//
//  OTPViewModel.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 25/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Repository
import RxSwift
import Entities
import RxCocoa

class OTPViewModel: BaseViewModel, IOTPViewModel {
    var otpResponse: PublishSubject<AppUser> = PublishSubject()
    var resendOTPResponse: PublishSubject<PhoneNumberAuth> = PublishSubject()
    let authRepo: IAuthRepo
    var countDownTime: PublishSubject<String> = PublishSubject()
    var timeLeft: Int? = 0
    var timer = Timer()
    
    init(authRepo: IAuthRepo) {
        self.authRepo = authRepo
    }
    
    func verifyOTPCode(code: String, phone: String) {
        var reqBody = [String: String]()
        reqBody["phoneNumber"] = phone
        reqBody["code"] = String(code)
        reqBody["platform"] = "ios"
        
        guard String(code).count == 5 else {
            self.alertValue.onNext(AlertValue(message: "Please enter the 5 digit code", type: .error))
            return
        }
        
        self.isLoading.onNext(true)
        authRepo.verify(requestBody: reqBody).subscribe(onNext: { [weak self] res in
            self?.isLoading.onNext(false)
            if let otpRes = res.data {
                self?.otpResponse.onNext(otpRes)
                self?.storeUserDetails(user: otpRes)
            } else if let apiErr = res.error {
                self?.apiError.onNext(apiErr)
            }
        }, onError: { [weak self] error in
            self?.isLoading.onNext(false)
            self?.throwableError.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    func storeUserDetails(user: AppUser) {
        authRepo.saveUserToken(token: user.token)
        authRepo.saveLoggedInUser(user: user.user)
    }
    
    func stopCountdown() {
        timeLeft = nil
        timer.invalidate()
    }
    
    func resendOTP(to phoneNumber: String, type: NotificationType) {
        stopCountdown()
        isLoading.onNext(true)
        authRepo.authenticate(requestBody: ["phoneNumber": phoneNumber, "type": type.rawValue]).subscribe(onNext: { [weak self] res in
            self?.isLoading.onNext(false)
            if let authRes = res.data {
                self?.resendOTPResponse.onNext(authRes)
            } else if let apiErr = res.error {
                self?.apiError.onNext(apiErr)
            }
        }, onError: { [weak self] error in
            self?.isLoading.onNext(false)
            self?.throwableError.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    func startCountdown(from start: Int) {
        self.countDownTime.onNext(String(format: "%02d", start))
        self.timeLeft = start
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self]_ in
            self?.timeLeft! -= 1
            self?.countDownTime.onNext(String(format: "%02d", (self?.timeLeft ?? 0)))
            if self?.timeLeft ?? 0 <= 0 {
                self?.timer.invalidate()
                self?.timeLeft = nil
            }
        })
    }
}
