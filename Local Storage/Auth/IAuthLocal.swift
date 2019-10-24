//
//  IAuthLocal.swift
//  Local Storage
//
//  Created by Isaac Iniongun on 25/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Entities
import RxSwift

public protocol IAuthLocal {
    
    func saveLoggedInUser(user: User)
    
    func getLoggedInUser() -> Observable<User?>
    
}
