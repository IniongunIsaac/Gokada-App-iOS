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
    func getDestinationHistory() -> Observable<[DestinationSearchQuery]?>
    func saveDestinationHistory(history: DestinationSearchQuery)
    func getRideEstimates(requestBody: [String: Any]) -> Observable<ApiResponse<RideEstimates>>
    func requestRide(requestBody: [String: Any]) -> Observable<ApiResponse<RequestRide>>
    func rating(requestBody: [String : String]) -> Observable<ApiResponse<RatingItem>>
}
