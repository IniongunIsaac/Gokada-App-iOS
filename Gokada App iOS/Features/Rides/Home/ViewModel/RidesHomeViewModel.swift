//
//  RidesHomeViewModel.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 30/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Repository
import Entities
import RxSwift
import RxCocoa

class RidesHomeViewModel: BaseViewModel, IRidesHomeViewModel {
    let ridesRepo: IRidesRepo
    
    init(ridesRepo: IRidesRepo) {
        self.ridesRepo = ridesRepo
    }
}
