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
        return makeAPIRequestObservable(responseType: ApiResponse<PhoneNumberAuth>.self, url: RemoteApiConstants.AUTH_URL, method: .post, params: requestBody, encoding: JSONEncoding.default)
    }
    
}
