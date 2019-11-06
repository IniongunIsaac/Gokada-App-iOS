//
//  RideEstimates.swift
//  Entities
//
//  Created by Emmanuel Okwara on 06/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public struct RideEstimates: Codable {
    public let status: String
    public let requestedPickup: PickupInfo
    public let requestedDropOff: PickupInfo
    public let codedCoordinates: String
    public let totalsEstimated: TotalsEstimated
}
