//
//  WelcomeViewModel.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 26/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Repository
import Entities
import RxSwift

class WelcomeViewModel: BaseViewModel, IWelcomeViewModel  {
    let authRepo: IAuthRepo
    var userResponse: PublishSubject<User> = PublishSubject()
    
    init(authRepo: IAuthRepo) {
        self.authRepo = authRepo
    }
    
    func userLoggedIn() -> Bool {
        let loggedInStatus = authRepo.getLoggedInStatus()
        return loggedInStatus != nil && loggedInStatus == "true"
    }
    
    func getLoggedInUserDetails() {
        authRepo.getLoggedInUser()
            .subscribe(onNext: { [weak self] user in
                self?.userResponse.onNext(user!)
        }, onError: {[weak self] error in
            self?.throwableError.onNext(error)
        }).disposed(by: disposeBag)
    }
}
