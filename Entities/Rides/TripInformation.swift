//
//  TripInformation.swift
//  Entities
//
//  Created by Emmanuel Okwara on 03/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public struct TripInformation {
    public var source: DestinationSearchQuery
    public var destination: DestinationSearchQuery
    
    public init(from source: DestinationSearchQuery, to destination: DestinationSearchQuery) {
        self.source = source
        self.destination = destination
    }
}
