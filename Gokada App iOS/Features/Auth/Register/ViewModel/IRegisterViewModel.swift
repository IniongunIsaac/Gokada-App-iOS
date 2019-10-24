//
//  IRegisterViewModel.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 25/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import RxSwift
import Entities
import RxCocoa

protocol IRegisterViewModel {
    var registerResponse: PublishSubject<User> { get }
    func registerUser(profileDetails: [String: String])
}
