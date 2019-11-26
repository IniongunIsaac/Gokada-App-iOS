//
//  ChargeData.swift
//  Entities
//
//  Created by Isaac Iniongun on 18/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public struct ChargeData: Codable {
    
    public let isApproved: Bool
    public let token: String
    public let tokenExpiry: String
    
    enum CodingKeys: String, CodingKey {
        case isApproved = "is_approved"
        case token
        case tokenExpiry = "token_expiry"
    }
    
    public init(decoder: Decoder) throws {
        //Get the root of our object
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //Decode id from container(the root)
        isApproved = try container.decode(Bool.self, forKey: .isApproved)
        token = try container.decode(String.self, forKey: .token)
        tokenExpiry = try container.decode(String.self, forKey: .tokenExpiry)
        
    }
}
