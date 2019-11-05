//
//  EditProfileViewModel.swift
//  Gokada App iOS
//
//  Created by Isaac Iniongun on 25/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Repository
import Entities
import RxSwift

class EditProfileViewModel: BaseViewModel, IEditProfileViewModel {
    
    var authRepo: IAuthRepo
    
    var userDetails: PublishSubject<User> = PublishSubject()
    
    var profileUpdateResponse: PublishSubject<User> = PublishSubject()
    
    var user: User? = nil
    
    init(authRepo: IAuthRepo) {
        self.authRepo = authRepo
    }
    
    override func viewDidLoad() {
        //getUserDetails()
    }
    
    func getUserDetails() {
        authRepo.getLoggedInUser()
            .subscribe(onNext: { [weak self] user in
                self?.user = user
                self?.userDetails.onNext(user!)
        }, onError: {[weak self] error in
            self?.throwableError.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    func updateUserDetails(requestBody: [String : String]) {
        
        if let error = AuthValidation.isValidUserProfileDetails(profileDetails: requestBody) {
            self.alertValue.onNext(AlertValue(message: error, type: .error))
            return
        }
        
        self.isLoading.onNext(true)
        
        self.authRepo.updateUserProfile(requestBody: requestBody).subscribe(onNext: { [weak self] res in
            
            self?.isLoading.onNext(false)
            
            if let profUpdtRes = res.data {
                
                self?.authRepo.saveLoggedInUser(user: profUpdtRes)
                
                self?.profileUpdateResponse.onNext(profUpdtRes)
                
            } else if let apiErr = res.error {
                
                self?.apiError.onNext(apiErr)
                
            }
            
        }, onError: { [weak self] error in
            
            self?.isLoading.onNext(false)
            
            self?.throwableError.onNext(error)
            
        }).disposed(by: disposeBag)
        
    }
}
