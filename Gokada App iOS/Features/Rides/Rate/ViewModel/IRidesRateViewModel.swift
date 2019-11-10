//
//  IRidesRateViewModel.swift
//  Gokada App iOS
//
//  Created by Oladipupo Oluwatobi Hammed on 31/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//


import Foundation
import Repository
import Entities
import RxSwift

protocol IRidesRateViewModel {
    
    var riderRatingUpdateResponse: PublishSubject<RatingItem> { get }
        
    
    func updateRiderRating(to value: String, comment: String)
}
