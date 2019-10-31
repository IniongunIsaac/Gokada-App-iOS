//
//  DestinationSearchQueries.swift
//  Entities
//
//  Created by Emmanuel Okwara on 31/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers public class DestinationSearchQueries: Object {
    public dynamic var queries = List<String>()
    
    public convenience required init(queries: List<String>) {
        self.init()
        self.queries = queries
    }
}
