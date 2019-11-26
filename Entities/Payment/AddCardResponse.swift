//
//  AddCardResponse.swift
//  Entities
//
//  Created by Isaac Iniongun on 18/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public struct AddCardResponse: Codable {
    public let authType: String?
    public let authTypeId: String?
    public let redirectUrl: String?
    public let source: String?
    public let status: String?
    public let message: String?
}
