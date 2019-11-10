//
//  RidesRateViewModel.swift
//  Gokada App iOS
//
//  Created by Oladipupo Oluwatobi Hammed on 31/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Repository
import Entities
import RxSwift
import RxCocoa

class RidesRateViewModel: BaseViewModel, IRidesRateViewModel {
   
    let ridesRepo: IRidesRepo
    var riderRatingUpdateResponse: PublishSubject<RatingItem> = PublishSubject()
    
      init(ridesRepo: IRidesRepo) {
          self.ridesRepo = ridesRepo
      }
    
    func updateRiderRating(to value: String, comment: String) {
             updateRider(to: value, comment: comment)
       }
    
  
    
    func updateRider(to value:String, comment: String ) {
            isLoading.onNext(true)
        ridesRepo.rating(requestBody:["value": value, "feedback": value] ).subscribe(onNext: { [weak self] res in
            self?.isLoading.onNext(false)
            if let authRes = res.data {
                self?.riderRatingUpdateResponse.onNext(authRes)
            } else if let apiErr = res.error {
                self?.apiError.onNext(apiErr)
            }
                
            }, onError: { [weak self] error in
                
                self?.isLoading.onNext(false)
                
                self?.throwableError.onNext(error)
                
            }).disposed(by: disposeBag)
            
        }
  
    
}
