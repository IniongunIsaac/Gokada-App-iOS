//
//  IRidesRemote.swift
//  Remote API
//
//  Created by Emmanuel Okwara on 30/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import RxSwift
import Entities

public protocol IRidesRemote {
    func rating(requestBody: [String : String]) -> Observable<ApiResponse<RatingItem>>
}
