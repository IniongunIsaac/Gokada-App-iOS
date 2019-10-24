//
//  IAuthRemote.swift
//  Remote API
//
//  Created by Isaac Iniongun on 22/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import RxSwift
import Entities

public protocol IAuthRemote {
    func authenticate(requestBody: [String : String]) -> Observable<ApiResponse<PhoneNumberAuth>>
    func verify(requestBody: [String: String]) -> Observable<ApiResponse<AppUser>>
    func updateProfile(requestBody: [String: String]) -> Observable<ApiResponse<User>>
}
