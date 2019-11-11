//
//  EstimatedLocation.swift
//  Entities
//
//  Created by Emmanuel Okwara on 08/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public struct EstimatedLocation: Codable {
    public let type: String
    public let coordinates: [Double]
}
