//
//  WelcomeViewModel.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 26/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Repository

class WelcomeViewModel: BaseViewModel, IWelcomeViewModel  {
    let authRepo: IAuthRepo
    
    init(authRepo: IAuthRepo) {
        self.authRepo = authRepo
    }
    
    func userLoggedIn() -> Bool {
        let loggedInStatus = authRepo.getLoggedInStatus()
        return loggedInStatus != nil && loggedInStatus == "true"
    }
}
