//
//  ISearchDestinationViewModel.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 01/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import RxSwift
import Entities

protocol ISearchDestinationViewModel {
    var placesSuggestion: PublishSubject<[DestinationSearchQuery]> { get }
    var coordinatesDetails: PublishSubject<LocationAddress> { get }
    func fetchPlaceSuggestion(query: String)
    func initializePlaceSuggestion()
}
