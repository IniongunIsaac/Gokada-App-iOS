//
//  AuthRemoteImpl.swift
//  Remote API
//
//  Created by Isaac Iniongun on 22/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import RxSwift
import Entities
import Alamofire

public class AuthRemoteImpl: BaseRemoteApiImpl, IAuthRemote {
    public override init() { }
    
    public func authenticate(requestBody: [String : String]) -> Observable<ApiResponse<PhoneNumberAuth>> {
        return makeAPIRequestObservable(responseType: ApiResponse<PhoneNumberAuth>.self, url: RemoteApiConstants.LOGIN_URL, method: .post, params: requestBody, encoding: JSONEncoding.default)
    }
    
    public func verify(requestBody: [String : String]) -> Observable<ApiResponse<AppUser>> {
        return makeAPIRequestObservable(responseType: ApiResponse<AppUser>.self, url: RemoteApiConstants.OTP_VERIFICATION, method: .post, params: requestBody, encoding: JSONEncoding.default)
    }
    
    public func updateProfile(requestBody: [String : String]) -> Observable<ApiResponse<User>> {
        return makeAPIRequestObservable(responseType: ApiResponse<User>.self, url: RemoteApiConstants.UPDATE_PROFILE, method: .patch, params: requestBody, encoding: JSONEncoding.default)
    }
    
}
