//
//  SearchDestinationViewModel.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 01/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Repository
import Entities
import RxSwift
import RxCocoa
import GooglePlaces

class SearchDestinationViewModel: BaseViewModel, ISearchDestinationViewModel {
    var placesSuggestion: PublishSubject<[String]> = PublishSubject()
    let token = GMSAutocompleteSessionToken.init()
    let filter = GMSAutocompleteFilter()
    
    let ridesRepo: IRidesRepo
    
    init(ridesRepo: IRidesRepo) {
        self.ridesRepo = ridesRepo
    }
    
    func initializePlaceSuggestion() {
        placesSuggestion.onNext(["Choose Location on Map"])
    }
    
    func fetchPlaceSuggestion(query: String) {
        GMSPlacesClient().findAutocompletePredictions(fromQuery: query,
                                                  bounds: nil,
                                                  boundsMode: GMSAutocompleteBoundsMode.bias,
                                                  filter: filter,
                                                  sessionToken: token,
                                                  callback: { [weak self] (results, error) in
            if let _ = error { return }
                                                    
            if let results = results {
                var suggestions = ["Choose Location on Map"]
                for result in results {
                    suggestions.append(result.attributedFullText.string)
                }
                self?.placesSuggestion.onNext(suggestions)
            }
        })
    }
}
