//
//  IOTPViewModel.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 25/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Entities
import RxSwift
import RxCocoa

protocol IOTPViewModel {
    var otpResponse: PublishSubject<AppUser> { get }
    var resendOTPResponse: PublishSubject<PhoneNumberAuth> { get }
    var countDownTime: PublishSubject<String> { get }
    func verifyOTPCode(code: String, phone: String)
    func startCountdown(from start: Int)
    func resendOTP(to phoneNumber: String, type: NotificationType)
    func stopCountdown()
}
