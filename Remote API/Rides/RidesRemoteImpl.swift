//
//  RidesRemoteImpl.swift
//  Remote API
//
//  Created by Emmanuel Okwara on 30/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//


import Foundation
import RxSwift
import Entities
import Alamofire

public class RidesRemoteImpl: BaseRemoteApiImpl, IRidesRemote {
    public override init() { }
    
    
    public func rating(requestBody: [String : String]) -> Observable<ApiResponse<RatingItem>> {
        return makeAPIRequestObservable(responseType: ApiResponse<RatingItem>.self, url: RemoteApiConstants.RATE_USER_RIDE_URL, method: .post, params: requestBody, encoding: JSONEncoding.default)
    }
}
