//
//  IBaseRemoteApi.swift
//  Remote API
//
//  Created by Isaac Iniongun on 22/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

protocol IBaseRemoteApi {
    func makeAPIRequest<T: Codable>(responseType: T.Type, url: String, method: HTTPMethod, params: [String : Any]?, encoding: ParameterEncoding, successHandler: @escaping (T) -> Void, errorHandler: @escaping (Error) -> Void)
    
    func makeAPIRequestObservable<T: Codable>(responseType: T.Type, url: String, method: HTTPMethod, params: [String : Any]?, encoding: ParameterEncoding) -> Observable<T>
}
