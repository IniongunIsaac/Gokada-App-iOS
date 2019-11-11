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
    
    public func saveDestinationHistory(history: DestinationSearchQuery) {
        let histories = realm.objects(DestinationSearchQuery.self).sorted(byKeyPath: "updatedAt", ascending: false)
        
        try! realm.write {
            if queryExists(query: history, in: histories.toArray()) {
                updateDestinationHistory(history: history)
            } else {
                if histories.count == 5 {
                    realm.delete(histories.last!)
                }
                realm.add(history)
            }
        }
    }
    
    public func clearSearchHistory() {
        try! realm.write {
            realm.delete(realm.objects(DestinationSearchQuery.self))
        }
    }
    
    public func getDestinationHistory() -> Observable<[DestinationSearchQuery]?> {
        let histories = realm.objects(DestinationSearchQuery.self).sorted(byKeyPath: "updatedAt", ascending: false)
        return Observable.just(histories.toArray())
    }
    
    private func updateDestinationHistory(history: DestinationSearchQuery) {
        let historyObj = realm.object(ofType: DestinationSearchQuery.self, forPrimaryKey: history.address)
        historyObj?.updateTime()
    }
    
    private func queryExists(query: DestinationSearchQuery, in list: [DestinationSearchQuery]) -> Bool {
        return (list.first(where: { $0.address == query.address }) != nil)
    }
    
}
