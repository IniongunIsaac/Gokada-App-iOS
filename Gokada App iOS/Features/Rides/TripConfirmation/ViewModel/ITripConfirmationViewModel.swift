//
//  ITripConfirmationViewModel.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 03/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import RxSwift
import Entities

protocol ITripConfirmationViewModel {
    var userPaymentOptions: PublishSubject<[UserPaymentOptions]> { get }
    var rideEstimationResponse: PublishSubject<RideEstimates> { get }
    var newRideResponse: PublishSubject<RequestRide> { get }
    func saveSearchHistory(query: DestinationSearchQuery)
    func fetchPaymentOptions()
    func updateDefaultPayment(accountNumber: String)
    var sourceCoordinatesResponse: PublishSubject<DestinationSearchQuery> { get }
    var destinationCoordinatesResponse: PublishSubject<DestinationSearchQuery> { get }
    func getLocationsCoordinates(tripInformation: TripInformation)
    func getRideEstimates(source: DestinationSearchQuery, destination: DestinationSearchQuery)
    func requestRide(source: DestinationSearchQuery, destination: DestinationSearchQuery, estimates: RideEstimates)
}
