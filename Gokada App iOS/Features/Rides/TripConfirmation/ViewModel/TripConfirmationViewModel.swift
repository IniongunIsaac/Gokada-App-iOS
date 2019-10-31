//
//  TripConfirmationViewModel.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 03/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Repository

class TripConfirmationViewModel: BaseViewModel, ITripConfirmationViewModel {
    
    let ridesRepo: IRidesRepo
    
    
    init(ridesRepo: IRidesRepo) {
        self.ridesRepo = ridesRepo
    }
    
    func saveSearchHistory(query: String) {
        ridesRepo.getDestinationHistory().subscribe(onNext: { [weak self] history in
            if let queries = history?.queries {
                let currentQueries = Array(queries)
                var newHistories = self?.removeDuplicate(text: query, in: currentQueries)
                newHistories = self?.firstInFirstOut(new: query, current: currentQueries, max: 5)
                self?.ridesRepo.saveDestinationHistory(histories: newHistories!)
            }
        }, onError: {[weak self] error in
            self?.throwableError.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    func firstInFirstOut(new: String, current: [String], max: Int) -> [String] {
        var newList = current
        if current.count == max {
            newList.remove(at: max - 1)
            newList.insert(new, at: 0)
        } else {
            newList.insert(new, at: 0)
        }
        
        return newList
    }
    
    func removeDuplicate(text: String, in list: [String]) -> [String] {
        var newList = list
        if let index = list.firstIndex(of: text) {
            newList.remove(at: index)
        }
        return newList
    }
}
