//
//  AuthLocalImpl.swift
//  Local Storage
//
//  Created by Isaac Iniongun on 25/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import RxSwift
import RxRealm
import Entities
import RealmSwift

public class AuthLocalImpl: IAuthLocal {
    
    public init() { }
    
    // Get the default Realm
    fileprivate let realm = try! Realm()
    
    public func saveLoggedInUser(user: User) {
        // Add to the Realm inside a transaction
        try! realm.write {
            realm.delete(realm.objects(User.self))
            realm.add(user)
        }
    }
    
    public func getLoggedInUser() -> Observable<User?> {
        return Observable.just(realm.object(ofType: User.self, forPrimaryKey: String.self))
    }
    
}
