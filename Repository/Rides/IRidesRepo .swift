//
//  IRidesRepo .swift
//  Repository
//
//  Created by Emmanuel Okwara on 30/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//



import Foundation
import RxSwift
import Entities

public protocol IRidesRepo {
    func rating(requestBody: [String : String]) -> Observable<ApiResponse<RatingItem>>
    
}
