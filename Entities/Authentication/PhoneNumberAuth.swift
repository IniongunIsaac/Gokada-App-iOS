//
//  PhoneNumberAuth.swift
//  Entities
//
//  Created by Isaac Iniongun on 22/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public struct PhoneNumberAuth: Codable {
    let phoneNumber: String
    let status: String
    let timeToLive: Int
}