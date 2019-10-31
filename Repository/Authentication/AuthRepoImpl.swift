//
//  AuthRepoImpl.swift
//  Repository
//
//  Created by Isaac Iniongun on 21/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import RxSwift
import Entities
import Remote_API
import App_Preferences
import Local_Storage

public struct AuthRepoImpl: IAuthRepo {
    
    public let authRemote: IAuthRemote?
    public let authLocal: IAuthLocal?
    public let ridesLocal: IRidesLocal?
    
    public init(authRemote: IAuthRemote, authLocal: IAuthLocal, ridesLocal: IRidesLocal) {
        self.authRemote = authRemote
        self.authLocal = authLocal
        self.ridesLocal = ridesLocal
    }
    
    public func authenticate(requestBody: [String : String]) -> Observable<ApiResponse<PhoneNumberAuth>> {
        return authRemote!.authenticate(requestBody: requestBody)
    }
    
    public func verify(requestBody: [String : String]) -> Observable<ApiResponse<AppUser>> {
        return authRemote!.verify(requestBody: requestBody)
    }
    
    public func saveUserToken(token: String) {
        Preference.saveAuthorizationHeader(value: token)
    }
    
    public func updateUserProfile(requestBody: [String : String]) -> Observable<ApiResponse<User>> {
        return authRemote!.updateUserProfile(requestBody: requestBody)
    }
    
    public func getLoggedInStatus() -> String? {
        return Preference.getUserLoginStatus()
    }
    
    public func getLoggedInUser() -> Observable<User?> {
        return authLocal!.getLoggedInUser()
    }
    
    public func saveLoggedInUser(user: User) {
        if user.firstName != nil {
            Preference.saveUserLoginStatus(value: "true")
            authLocal?.saveLoggedInUser(user: user)
        }
    }
    
    public func deleteLoggedInUserDetails() {
        Preference.saveUserLoginStatus(value: "false")
        authLocal!.deleteLoggedInUserDetails()
        ridesLocal?.clearSearchHistory()
    }
    
}
