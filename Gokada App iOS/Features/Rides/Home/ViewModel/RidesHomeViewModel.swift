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
    var searchHistory: PublishSubject<[DestinationSearchQuery]> = PublishSubject()
    let ridesRepo: IRidesRepo
    
    init(ridesRepo: IRidesRepo) {
        self.ridesRepo = ridesRepo
    }
    
    func getDestinationSearchHistory() {
        ridesRepo.getDestinationHistory().subscribe(onNext: { [weak self] histories in
            self?.searchHistory.onNext(histories ?? [])
        }, onError: {[weak self] error in
            self?.throwableError.onNext(error)
        }).disposed(by: disposeBag)
    }
}
