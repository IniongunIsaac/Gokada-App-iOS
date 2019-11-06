//
//  IRidesLocal.swift
//  Local Storage
//
//  Created by Emmanuel Okwara on 30/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Entities
import RxSwift

public protocol IRidesLocal {
    func saveDestinationHistory(history: DestinationSearchQuery)
    func getDestinationHistory() -> Observable<[DestinationSearchQuery]?>
    func clearSearchHistory()
}
