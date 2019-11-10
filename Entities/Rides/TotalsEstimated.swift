//
//  TotalsEstimated.swift
//  Entities
//
//  Created by Emmanuel Okwara on 08/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public struct TotalsEstimated: Codable {
    public var tollFees: [Double]
    public var distance: Double
    public var duration: Double
    public var totalFrom: Double
    public var total: Double
    public var totalTo: Double
}
