//
//  BaseRemoteMock.swift
//  Remote APITests
//
//  Created by Emmanuel Okwara on 27/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
@testable import Remote_API

class BaseRemoteAuthMock: IBaseRemoteApi {
    var requestMade = false
    
    func makeAPIRequest<T>(responseType: T.Type, url: String, method: HTTPMethod, params: [String : Any]?, encoding: ParameterEncoding, successHandler: @escaping (T) -> Void, errorHandler: @escaping (Error) -> Void) where T : Decodable, T : Encodable {
        requestMade = true
    }
    
    func makeAPIRequestObservable<T>(responseType: T.Type, url: String, method: HTTPMethod, params: [String : Any]?, encoding: ParameterEncoding) -> Observable<T> where T : Decodable, T : Encodable {
        requestMade = true
    }
}
