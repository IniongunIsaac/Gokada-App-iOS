//
//  LocationAddress.swift
//  Entities
//
//  Created by Emmanuel Okwara on 06/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public struct LocationAddress {
    public let id: String?
    public let latitude: Double?
    public let longitude: Double?
    public let description: String
    
    public init(id: String?, latitude: Double?, longitude: Double?, description: String) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.description = description
    }
}
