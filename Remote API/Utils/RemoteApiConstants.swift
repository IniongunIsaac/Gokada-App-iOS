//
//  RemoteApiConstants.swift
//  Remote API
//
//  Created by Isaac Iniongun on 22/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

struct RemoteApiConstants {
    fileprivate static let BASE_URL = "https://09yv3jwnq5.execute-api.eu-west-1.amazonaws.com/staging/"
    
    // MARK:- AUTHENTICATION APIs
    static let LOGIN_URL = "\(BASE_URL)authenticate"
    static let OTP_VERIFICATION_URL = "\(BASE_URL)authenticate/verify"
    static let UPDATE_USER_PROFILE_URL = "\(BASE_URL)user"
    
    
    // MARK:- RIDES APIs
    static let RIDE_ESTIMATES_URL = "\(BASE_URL)user/rides/fare"
    static let REQUEST_RIDE_URL = "\(BASE_URL)user/rides"
    static let RATE_USER_RIDE_URL =  "\(BASE_URL)user/rides/5dc2980d3b2a840008365d4b/rate"
}
