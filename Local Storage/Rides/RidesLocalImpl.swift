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
    
    public func saveDestinationHistory(queries: [String]) {
        
        try! realm.write {
            realm.delete(realm.objects(DestinationSearchQueries.self))
            
            let queriesList = List<String>()
            queriesList.append(objectsIn: queries)
            
            realm.add(DestinationSearchQueries(queries: queriesList))
        }
    }
    
    public func clearSearchHistory() {
        try! realm.write {
            realm.delete(realm.objects(DestinationSearchQueries.self))
        }
    }
    
    public func getDestinationHistory() -> Observable<DestinationSearchQueries?> {
        return Observable.just(realm.objects(DestinationSearchQueries.self).first)
    }
    
}
