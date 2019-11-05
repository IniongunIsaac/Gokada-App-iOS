//
//  ISearchDestinationViewModel.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 01/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import RxSwift

protocol ISearchDestinationViewModel {
    var placesSuggestion: PublishSubject<[String]> { get }
    func fetchPlaceSuggestion(query: String)
    func initializePlaceSuggestion()
}
