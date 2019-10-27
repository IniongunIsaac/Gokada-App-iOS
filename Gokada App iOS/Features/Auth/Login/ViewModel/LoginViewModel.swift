//
//  AuthViewModel.swift
//  Gokada App iOS
//
//  Created by Isaac Iniongun on 22/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Repository
import Entities
import RxSwift
import RxCocoa

class LoginViewModel: BaseViewModel, ILoginViewModel {
    
    let authRepo: IAuthRepo
    
    var loginResponse: PublishSubject<PhoneNumberAuth> = PublishSubject()
    
    init(authRepo: IAuthRepo) {
        self.authRepo = authRepo
    }
    
    func sendOTPCode(to phoneNumber: String) {
        if let error = AuthValidation.validLogin(phoneNumber) {
            self.alertValue.onNext(AlertValue(message: error, type: .error))
            return
        }
        
        send(to: phoneNumber, type: .sms)
    }
    
    func send(to phoneNumber: String, type: NotificationType) {
        isLoading.onNext(true)
        authRepo.authenticate(requestBody: ["phoneNumber": phoneNumber, "type": type.rawValue]).subscribe(onNext: { [weak self] res in
            self?.isLoading.onNext(false)
            if let authRes = res.data {
                self?.loginResponse.onNext(authRes)
            } else if let apiErr = res.error {
                self?.apiError.onNext(apiErr)
            }
        }, onError: { [weak self] error in
            self?.isLoading.onNext(false)
            self?.throwableError.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
    }
    
}
