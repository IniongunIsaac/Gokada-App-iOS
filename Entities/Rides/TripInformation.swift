//
//  TripInformation.swift
//  Entities
//
//  Created by Emmanuel Okwara on 03/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public struct TripInformation {
    public let source: String
    public let destination: String
    
    public init(from source: String, to destination: String) {
        self.source = source
        self.destination = destination
    }
}
