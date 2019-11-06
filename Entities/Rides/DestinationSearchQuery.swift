//
//  DestinationSearchQueries.swift
//  Entities
//
//  Created by Emmanuel Okwara on 31/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers public class DestinationSearchQuery: Object {
    public dynamic var id: String? = ""
    public dynamic var address: String = ""
    public dynamic var latitude: Double = 0.0
    public dynamic var longitude: Double = 0.0
    public dynamic var updatedAt: Double = 0.0
    
    public override class func primaryKey() -> String? {
        return "address"
    }
    
    public convenience required init(id: String?, address: String, latitude: Double?, longitude: Double?) {
        self.init()
        self.id = id
        self.address = address
        self.latitude = latitude ?? 0.0
        self.longitude = longitude ?? 0.0
        self.updateTime()
    }
    
    public func updateTime() {
        updatedAt = Date().timeIntervalSince1970 * 1000
    }
}
