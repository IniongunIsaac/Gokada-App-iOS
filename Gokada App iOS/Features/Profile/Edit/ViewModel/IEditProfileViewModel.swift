//
//  File.swift
//  Gokada App iOS
//
//  Created by Isaac Iniongun on 25/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Repository
import Entities
import RxSwift

protocol IEditProfileViewModel {
    
    var userDetails: PublishSubject<User> { get set }
    
    var profileUpdateResponse: PublishSubject<User> { get }
    
    var user: User? { get set }
    
    func getUserDetails()
    
    func updateUserDetails(requestBody: [String : String])
}
