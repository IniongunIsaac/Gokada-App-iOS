//
//  SuperAppUser.swift
//  Entities
//
//  Created by Isaac Iniongun on 21/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public struct AppUser: Decodable {
    let token: String
    let user: User
    
    func isRider() -> Bool {
        return !(user.roles?.contains("driver") ?? false)
    }
}
