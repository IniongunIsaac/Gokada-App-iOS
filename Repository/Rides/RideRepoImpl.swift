//
//  RideRepoImpl.swift
//  Repository
//
//  Created by Emmanuel Okwara on 30/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import RxSwift
import Entities
import Remote_API
import App_Preferences
import Local_Storage

public struct RidesRepoImpl: IRidesRepo {

    
    public let ridesRemote: IRidesRemote?
    public let ridesLocal: IRidesLocal?
    
    public init(ridesRemote: IRidesRemote, ridesLocal: IRidesLocal) {
        self.ridesRemote = ridesRemote
        self.ridesLocal = ridesLocal
    }
    
    public func getDestinationHistory() -> Observable<DestinationSearchQueries?> {
        return ridesLocal!.getDestinationHistory()
    }
    
    public func saveDestinationHistory(histories: [String]) {
        ridesLocal?.saveDestinationHistory(queries: histories)
}
public func rating(requestBody: [String : String]) -> Observable<ApiResponse<RatingItem>> {
       return ridesRemote!.rating(requestBody: requestBody)
   }
}
