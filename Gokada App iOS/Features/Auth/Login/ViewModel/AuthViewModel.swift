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

class AuthViewModel: BaseViewModel, IAuthViewModel {
    
    let authRepo: IAuthRepo
    
    init(authRepo: IAuthRepo) {
        self.authRepo = authRepo
    }
    
    let authResponse: Single<PhoneNumberAuth>? = nil
    
    override func viewDidLoad() {
        
    }
    
}
