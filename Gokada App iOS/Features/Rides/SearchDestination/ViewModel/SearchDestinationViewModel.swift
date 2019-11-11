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
    var placesSuggestion: PublishSubject<[DestinationSearchQuery]> = PublishSubject()
    let token = GMSAutocompleteSessionToken.init()
    let filter = GMSAutocompleteFilter()
    var coordinatesDetails: PublishSubject<LocationAddress> = PublishSubject()
    
    let ridesRepo: IRidesRepo
    
    init(ridesRepo: IRidesRepo) {
        self.ridesRepo = ridesRepo
    }
    
    func initializePlaceSuggestion() {
        placesSuggestion.onNext([DestinationSearchQuery(id: "1", address: "Choose Location on Map", latitude: nil, longitude: nil)])
    }
    
    func getCoordinatedBy(id placeID: String) {
        isLoading.onNext(true)
        let placesClient = GMSPlacesClient.shared()
        placesClient.lookUpPlaceID(placeID) { [weak self] (place, error) in
            self?.isLoading.onNext(false)
            if let error = error {
                self?.alertValue.onNext(AlertValue(message: "Could not retrieve location \(error.localizedDescription)", type: .error))
                return
            }

            guard let place = place else {
                self?.alertValue.onNext(AlertValue(message: "No place details for \(placeID)", type: .error))
                return
            }
            
            self?.coordinatesDetails.onNext(LocationAddress(id: nil, latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, description: place.formattedAddress ?? ""))
        }
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
                var suggestions = [DestinationSearchQuery(id: "1", address: "Choose Location on Map", latitude: nil, longitude: nil)]
                for result in results {
                    suggestions.append(DestinationSearchQuery(id: result.placeID, address: result.attributedFullText.string, latitude: nil, longitude: nil))
                }
                self?.placesSuggestion.onNext(suggestions)
            }
        })
    }
}
