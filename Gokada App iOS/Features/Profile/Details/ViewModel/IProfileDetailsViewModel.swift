//
//  IProfileDetailsViewModel.swift
//  Gokada App iOS
//
//  Created by Isaac Iniongun on 25/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Repository
import Entities
import RxSwift

protocol IProfileDetailsViewModel {
    //var authRepo: IAuthRepo? { get }
    var userDetails: PublishSubject<User> { get }
    
    var profileItems: PublishSubject<[ProfileItem]> {get set}
    
    var proItems: [ProfileItem] { get set }
    
    var user: User? { get set }
    
    func viewDidLoad1()
    
    func getLoggedInUserDetails()
    
    func logUserOut()
    
}
