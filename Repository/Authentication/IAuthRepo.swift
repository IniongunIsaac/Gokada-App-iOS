//
//  IAuthRepo.swift
//  Repository
//
//  Created by Isaac Iniongun on 22/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import RxSwift
import Entities

public protocol IAuthRepo {
    
    func authenticate(requestBody: [String : String]) -> Observable<ApiResponse<PhoneNumberAuth>>
    
    func verify(requestBody: [String: String]) -> Observable<ApiResponse<AppUser>>
    
    func updateUserProfile(requestBody: [String: String]) -> Observable<ApiResponse<User>>
    
    func saveUserToken(token: String)
    
    func getLoggedInStatus() -> String?
    
    func getLoggedInUser() -> Observable<User?>
    
    func saveLoggedInUser(user: User)
    
    func deleteLoggedInUserDetails()
}
