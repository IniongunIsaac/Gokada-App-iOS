//
//  ProfileItem.swift
//  Entities
//
//  Created by Isaac Iniongun on 26/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public struct ProfileItem {
    public let itemImageName: String
    public let itemName: String
    
    public init(itemImageName: String, itemName: String) {
        self.itemImageName = itemImageName
        self.itemName = itemName
    }
}
