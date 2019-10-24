//
//  IAuthViewModel.swift
//  Gokada App iOS
//
//  Created by Isaac Iniongun on 22/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import RxSwift
import Entities

protocol ILoginViewModel {
    var loginResponse: PublishSubject<PhoneNumberAuth> { get }
    func sendOTPCode(to phoneNumber: String)
}
