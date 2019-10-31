//
//  IWelcomeViewModel.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 26/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import RxSwift
import Entities
import RxCocoa

protocol IWelcomeViewModel {
    func userLoggedIn() -> Bool
    var userResponse: PublishSubject<User> { get }
    func getLoggedInUserDetails()
}
