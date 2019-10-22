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

public struct AuthRepoImpl: IAuthRepo {
    
    public let authRemote: IAuthRemote?
    
    public init(authRemote: IAuthRemote) {
        self.authRemote = authRemote
    }
    
    public func authenticate(requestBody: [String : String]) -> Observable<ApiResponse<PhoneNumberAuth>> {
        return authRemote!.authenticate(requestBody: requestBody)
    }
    
}
