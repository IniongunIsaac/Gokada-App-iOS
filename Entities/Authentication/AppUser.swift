//
//  AppUser.swift
//  Entities
//
//  Created by Isaac Iniongun on 22/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public struct AppUser: Codable {
    public let token: String
    public let user: User
    
    func isRider() -> Bool {
        return !(user.roles.contains("driver"))
    }
}
