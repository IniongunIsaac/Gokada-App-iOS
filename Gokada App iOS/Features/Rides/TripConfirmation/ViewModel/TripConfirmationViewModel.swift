//
//  TripConfirmationViewModel.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 03/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Repository
import Entities
import GooglePlaces
import RxSwift

class TripConfirmationViewModel: BaseViewModel, ITripConfirmationViewModel {
    var userPaymentOptions = PublishSubject<[UserPaymentOptions]>()
    let ridesRepo: IRidesRepo
    var options = [UserPaymentOptions]()
    var sourceCoordinatesResponse: PublishSubject<DestinationSearchQuery> = PublishSubject()
    var destinationCoordinatesResponse: PublishSubject<DestinationSearchQuery> = PublishSubject()
    var rideEstimationResponse: PublishSubject<RideEstimates> = PublishSubject()
    var newRideResponse: PublishSubject<RequestRide> = PublishSubject()
    
    init(ridesRepo: IRidesRepo) {
        self.ridesRepo = ridesRepo
    }
    
    func fetchPaymentOptions() {
        options.append(UserPaymentOptions(type: .cash, current: true))
        options.append(UserPaymentOptions(type: .visa, accountNumber: "visa3883892838"))
        options.append(UserPaymentOptions(type: .verve, accountNumber: "verve3883892838"))
        options.append(UserPaymentOptions(type: .master, accountNumber: "master3883892838"))
        options.append(UserPaymentOptions(type: .other))
        
        userPaymentOptions.onNext(options)
    }
    
    func getRideEstimates(source: DestinationSearchQuery, destination: DestinationSearchQuery) {
        let requestBody = extractRideInformation(source: source, destination: destination)
        self.isLoading.onNext(true)
        self.ridesRepo.getRideEstimates(requestBody: requestBody).subscribe(onNext: { [weak self] res in
            self?.isLoading.onNext(false)
            if let estimationRes = res.data {
                self?.rideEstimationResponse.onNext(estimationRes)
            } else if let apiErr = res.error {
                self?.apiError.onNext(apiErr)
            }
        }, onError: { [weak self] error in
            self?.isLoading.onNext(false)
            self?.throwableError.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    func requestRide(source: DestinationSearchQuery, destination: DestinationSearchQuery, estimates: RideEstimates) {
        self.isLoading.onNext(true)
        let requestBody = extractNewRideInformation(source: source, destination: destination, estimates: estimates)
        
        self.ridesRepo.requestRide(requestBody: requestBody).subscribe(onNext: { [weak self] res in
            self?.isLoading.onNext(false)
            if let rideInfo = res.data {
                self?.newRideResponse.onNext(rideInfo)
            } else if let apiErr = res.error {
                self?.apiError.onNext(apiErr)
            }
        }, onError: { [weak self] error in
            self?.isLoading.onNext(false)
            self?.throwableError.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    private func extractNewRideInformation(source: DestinationSearchQuery, destination: DestinationSearchQuery, estimates: RideEstimates) -> [String: Any] {
        return [
            "tripDataEstimated": [],
            "coordinates": [source.latitude, source.longitude],
            "currency": "₦",
            "totalsEstimated": extractEstimations(estimates: estimates.totalsEstimated),
            "userLocation": extractPickDropLocation(location: source),
            "requestedPickup": extractPickDropLocation(location: source, array: true),
            "requestedDropOff": extractPickDropLocation(location: destination, array: true),
            "address": source.address,
            "date": Date().iso8601,
            "iso3166": "NGA"
        ]
    }
    
    private func extractEstimations(estimates: TotalsEstimated) -> [String: Any] {
        return [
            "duration": estimates.duration,
            "distance": estimates.distance,
            "totalTo": estimates.totalTo,
            "total": estimates.total,
            "totalFrom": estimates.totalFrom
        ]
    }
    
    private func extractRideInformation(source: DestinationSearchQuery, destination: DestinationSearchQuery) -> [String: Any] {
        return [
            "iso3166": "NGA",
            "requestedPickup": extractPickDropLocation(location: source),
            "requestedDropOff": extractPickDropLocation(location: destination),
            "date": Date().iso8601
        ]
    }
    
    private func extractPickDropLocation(location: DestinationSearchQuery, array: Bool = false) -> [String: Any] {
        return [
            "address": location.address,
            "location": extractLocation(location: location, array: array),
            "date": Date().iso8601
        ]
    }
    
    private func extractLocation(location: DestinationSearchQuery, array: Bool = false) -> [String: Any] {
        return [
            "type": "Point",
            "coordinates": array ? [location.latitude, location.longitude] : ["longitude": location.longitude, "latitude": location.latitude]
        ]
    }
    
    func getLocationsCoordinates(tripInformation: TripInformation) {
        if tripInformation.source.latitude == 0 {
            fetchCoordinates(for: tripInformation.source.id ?? "", of: sourceCoordinatesResponse)
        }
        if tripInformation.destination.latitude == 0 {
            fetchCoordinates(for: tripInformation.destination.id ?? "", of: destinationCoordinatesResponse)
        }
    }
    
    private func fetchCoordinates(for locationID: String, of locationObservable: PublishSubject<DestinationSearchQuery>) {
        let placesClient = GMSPlacesClient.shared()
        placesClient.lookUpPlaceID(locationID) { (place, error) in
            if let error = error {
                self.alertValue.onNext(AlertValue(message: error.localizedDescription, type: .error))
                return
            }
            
            guard let place = place else {
                self.alertValue.onNext(AlertValue(message: "No place details for \(locationID)", type: .error))
                return
            }
            
            locationObservable.onNext(DestinationSearchQuery(id: place.placeID, address: place.formattedAddress ?? "", latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
        }
    }
    
    func updateDefaultPayment(accountNumber: String) {
        var updatedOptions = options
        for ind in 0 ..< options.count {
            if options[ind].accountNumber == accountNumber {
                updatedOptions[ind].current = true
            } else {
                updatedOptions[ind].current = false
            }
        }
        userPaymentOptions.onNext(updatedOptions)
    }
    
    func saveSearchHistory(query: DestinationSearchQuery) {
        ridesRepo.saveDestinationHistory(history: query)
    }
}
