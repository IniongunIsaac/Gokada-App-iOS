//
//  PickupInfo.swift
//  Entities
//
//  Created by Emmanuel Okwara on 08/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public struct PickupInfo: Codable {
    public let address: String
    public let location: EstimatedLocation
    public let date: String? = nil
}
