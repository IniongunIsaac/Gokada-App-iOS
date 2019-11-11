//
//  RequestRide.swift
//  Entities
//
//  Created by Emmanuel Okwara on 09/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public struct RequestRide: Codable {
    public let id: String
    public let searchId: String
    public let startCode: Int
    public let user: RideUser
    public let driver: RidePilot
    public let status: String
    public let requestedPickup: PickupInfo?
    public let requestedDropOff: PickupInfo?
    public let totalsEstimated: TotalsEstimated
}
