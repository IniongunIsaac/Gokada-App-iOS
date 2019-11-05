//
//  ProfileDetailsViewModel.swift
//  Gokada App iOS
//
//  Created by Isaac Iniongun on 25/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Repository
import Entities
import RxSwift
import RxCocoa

class ProfileDetailsViewModel: BaseViewModel, IProfileDetailsViewModel {
    //var authRepo: IAuthRepo?
    
    
    var userDetails: PublishSubject<User> = PublishSubject()
    let authRepo: IAuthRepo
    var profileItems: PublishSubject<[ProfileItem]> = PublishSubject()
    
    init(authRepo: IAuthRepo) {
        self.authRepo = authRepo
    }
    
    var proItems: [ProfileItem] = [
        ProfileItem(itemImageName: "payment_icon", itemName: "Payments"),
        ProfileItem(itemImageName: "promotions_icon", itemName: "Promotions"),
        ProfileItem(itemImageName: "ride_history_icon", itemName: "Ride History"),
        ProfileItem(itemImageName: "support_icon", itemName: "Support"),
        ProfileItem(itemImageName: "gokada_logo_icon", itemName: "About Gokada")
    ]
    
    var user: User? = nil
    
    fileprivate func emitProfileItems() {
        
        profileItems.onNext(proItems)
        
        profileItems.on(.next([ProfileItem(itemImageName: "payment_icon", itemName: "Payments")]))
        
        profileItems.subscribe(onNext: { proItems in
            }).disposed(by: disposeBag)
    }
    
    func viewDidLoad1() {
    }
    
    func getLoggedInUserDetails() {
        authRepo.getLoggedInUser()
            .subscribe(onNext: { [weak self] user in
                self?.user = user
                self?.userDetails.onNext(user!)
        }, onError: {[weak self] error in
            self?.throwableError.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    func logUserOut() {
        authRepo.deleteLoggedInUserDetails()
    }
    
    
}
