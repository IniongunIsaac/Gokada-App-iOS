//
//  TotalsEstimated.swift
//  Entities
//
//  Created by Emmanuel Okwara on 08/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public struct TotalsEstimated: Codable {
    public var tollFees: [Double]? = []
    public var distance: Double? = 0.0
    public var duration: Double? = 0.0
    public var totalFrom: Double? = 0.0
    public var total: Double? = 0.0
    public var totalTo: Double? = 0.0
}
