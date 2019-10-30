//
//  IRidesLocalImpl.swift
//  Local Storage
//
//  Created by Emmanuel Okwara on 30/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import RxSwift
import RxRealm
import Entities
import RealmSwift

public class RidesLocalImpl: IRidesLocal {
    
    public init() { }
    
    fileprivate let realm = try! Realm()
    
}
