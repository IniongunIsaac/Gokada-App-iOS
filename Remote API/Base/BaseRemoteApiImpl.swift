//
//  BaseRemoteApiImpl.swift
//  Remote API
//
//  Created by Isaac Iniongun on 22/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift
import App_Preferences

public class BaseRemoteApiImpl: IBaseRemoteApi {
    
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate var requestHeaders: [String : String] {
        if let authHeader = Preference.getAuthorizationHeader() {
            return ["Content-Type": "application/json", "Accept": "application/json", "Authorization": authHeader]
        } else {
            return ["Content-Type": "application/json", "Accept": "application/json"]
        }
    }
    
    public func makeAPIRequest<T>(responseType: T.Type, url: String, method: HTTPMethod = .get, params: [String : Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, successHandler: @escaping (T) -> Void, errorHandler: @escaping (Error) -> Void) where T : Codable {
        
        _ = string(method, url, parameters: params, encoding: encoding, headers: requestHeaders)
            .debug()
            .subscribe(onNext: { responseString in
                do {
                    
                    //check if the `responseString` contains the `errors` key, create a new json string with key `error`
                    //otherwise, create a new json string with key `data`
                    let jsonString = responseString.localizedCaseInsensitiveContains("errors") ? try self.getJsonString(withKey: "error", forValue: responseString) : try self.getJsonString(withKey: "data", forValue: responseString)
                    
                    //map the result of `jsonString` above to the `responseType`
                    let requestResponse = try responseType.mapTo(jsonString: jsonString)!
                    
                    //return result in `requestResponse` above in the `successHandler`
                    successHandler(requestResponse)
                    
                } catch let error {
                    errorHandler(error)
                }
            }, onError: { error in
                errorHandler(error)
            })
            .disposed(by: disposeBag)
        
    }
    
    public func makeAPIRequestObservable<T>(responseType: T.Type, url: String, method: HTTPMethod = .get, params: [String : Any]?, encoding: ParameterEncoding = URLEncoding.default) -> Observable<T> where T : Codable {
        return string(method, url, parameters: params, encoding: encoding, headers: requestHeaders)
            .debug()
            .flatMap({ responseString -> Observable<T> in
                do {
                    
                    //check if the `responseString` contains the `errors` key, create a new json string with key `error`
                    //otherwise, create a new json string with key `data`
                    let jsonString = responseString.localizedCaseInsensitiveContains("errors") ? try self.getJsonString(withKey: "error", forValue: responseString) : try self.getJsonString(withKey: "data", forValue: responseString)
                    
                    //map the result of `jsonString` above to the `responseType`
                    let requestResponse = try responseType.mapTo(jsonString: jsonString)!
                    
                    //return result in `requestResponse` above in the `successHandler`
                    return Observable.just(requestResponse)
                    
                } catch let error {
                    throw error
                }
            })
    }
    
    /// Creates a new JSON String
    ///
    /// - Parameter withKey: key to be formed as part of the new json string
    /// - Parameter forValue: value of the aforementioned key
    /// - Returns: String
    fileprivate func getJsonString(withKey: String, forValue: String) throws -> String {
        let jsonStringDictionary = "{\"\(withKey)\": \(forValue)}"
        return jsonStringDictionary
    }
}
