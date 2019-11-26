//
//  Card.swift
//  Entities
//
//  Created by Isaac Iniongun on 18/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public struct Card: Codable {
    public let cardId: String
    public let cardPAN: String
    public let chargeData: ChargeData
    public let expiryDate: String
    public let isDefaultCard: Bool = false
}
