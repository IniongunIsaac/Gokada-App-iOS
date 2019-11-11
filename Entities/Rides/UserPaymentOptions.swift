//
//  UserPaymentOptions.swift
//  Entities
//
//  Created by Emmanuel Okwara on 06/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public enum PaymentMethods {
    case cash
    case visa
    case master
    case verve
    case other
}

public struct UserPaymentOptions {
    public let type: PaymentMethods!
    public let accountNumber: String?
    public var current: Bool
    
    public init(type: PaymentMethods, accountNumber: String = "Cash", current: Bool = false) {
        self.type = type
        self.accountNumber = accountNumber
        self.current = current
    }
}
