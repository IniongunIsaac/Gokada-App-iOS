//
//  User.swift
//  Entities
//
//  Created by Isaac Iniongun on 21/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public struct User: Codable {
    let id: String
    let firstName: String?
    let lastName: String?
    let phoneNumber: String?
    let driver: Pilot?
    let roles: [String]?
    let profileImage: String?
    let email: String?
    
    enum CodingKeys: String, CodingKey{
        case id = "_id", firstName, lastName, phoneNumber, driver, roles, profileImage, email
    }
    
    init(decoder: Decoder) throws {
        //Get the root of our object
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //Decode id from container(the root)
        id = try container.decode(String.self, forKey: .id)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        driver = try container.decodeIfPresent(Pilot.self, forKey: .driver)
        roles = try container.decodeIfPresent([String].self, forKey: .roles)
        profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
        email = try container.decodeIfPresent(String.self, forKey: .email)
    }
    
}
