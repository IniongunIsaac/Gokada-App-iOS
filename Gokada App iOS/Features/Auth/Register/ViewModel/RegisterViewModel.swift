//
//  RegisterViewModel.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 25/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import RxSwift
import Entities
import Repository

class RegisterViewModel: BaseViewModel, IRegisterViewModel  {
    var registerResponse: PublishSubject<User> = PublishSubject()
    let authRepo: IAuthRepo
    
    init(authRepo: IAuthRepo) {
        self.authRepo = authRepo
    }
    
    func registerUser(profileDetails: [String : String]) {
        if let error = AuthValidation.isValidUserProfileDetails(profileDetails: profileDetails) {
            self.alertValue.onNext(AlertValue(message: error, type: .error))
            return
        }
        
        self.isLoading.onNext(true)
        self.authRepo.updateUserProfile(requestBody: profileDetails).subscribe(onNext: { [weak self] res in
            self?.isLoading.onNext(false)
            if let regRes = res.data {
                self?.authRepo.saveLoggedInUser(user: regRes)
                self?.registerResponse.onNext(regRes)
            } else if let apiErr = res.error {
                self?.apiError.onNext(apiErr)
            }
        }, onError: { [weak self] error in
            self?.isLoading.onNext(false)
            self?.throwableError.onNext(error)
        }).disposed(by: disposeBag)
    }
}
