//
//  SearchDestinationViewController.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 01/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit
import GoogleMaps
import RxGoogleMaps
import Entities

class SearchDestinationViewController: BaseViewController {

    var searchDestinationViewModel: ISearchDestinationViewModel?
    
    @IBOutlet weak var sourceLocationField: UITextField!
    @IBOutlet weak var destinationLocationField: UITextField!
    @IBOutlet weak var suggestionTableView: UITableView!
    @IBOutlet weak var addressView: UIView!
    private let locationManager = CLLocationManager()
    var currentSearchField: UITextField?
    var currentLocation: DestinationSearchQuery!
    var destinationLocation: DestinationSearchQuery!
    
    override func getViewModel() -> BaseViewModel {
        return searchDestinationViewModel as! BaseViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addressView.dropShadow(color: UIColor.black, opacity: 0.1, offSet: CGSize(width: 0, height: 0), radius: 20, scale: true)
        locationManager.delegate = self
        destinationLocationField.becomeFirstResponder()
        
        bindViews()
        setupSearchBarListener()
        searchDestinationViewModel?.initializePlaceSuggestion()
    }
    
    fileprivate func setupSearchBarListener() {
        let sourcePublisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: sourceLocationField)
        let _ = sourcePublisher.map {
            ($0.object as! UITextField).text
        }.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.fetchPlaces(query: query ?? "")
        }
        
        let destinationPublisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: destinationLocationField)
        let _ = destinationPublisher.map {
            ($0.object as! UITextField).text
        }.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.fetchPlaces(query: query ?? "")
        }
    }
    
    @IBAction func searchDidBeginEditing(_ sender: UITextField) {
        self.currentSearchField = sender
    }
    
    @IBAction func searchDidEndEditing(_ sender: UITextField) {
        self.currentSearchField = nil
    }
    
    func fetchPlaces(query: String) {
       if (query).trimmingCharacters(in: .whitespacesAndNewlines).count >= 3 {
           searchDestinationViewModel?.fetchPlaceSuggestion(query: query)
       }
    }
    
    func bindViews() {
        searchDestinationViewModel?.placesSuggestion.bind(to: self.suggestionTableView.rx.items) { [weak self] (tableView, index, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlacesSuggestionTableViewCell") as! PlacesSuggestionTableViewCell
            
            if index == 0 {
                cell.updateView(address: element.address, icon: #imageLiteral(resourceName: "onlineIcon"))
                cell.addTapGesture { [weak self] in
                    self?.selectDestinationFromMap()
                }
            } else {
                cell.updateView(address: element.address, icon: #imageLiteral(resourceName: "maps-and-flags"))
                cell.addTapGesture { [weak self] in
                    self?.currentSearchField?.text = element.address
                    if self?.currentSearchField?.tag == 0 {
                        self?.currentLocation = DestinationSearchQuery(id: element.id, address: element.address, latitude: element.latitude, longitude: element.longitude)
                    } else {
                        self?.destinationLocation = DestinationSearchQuery(id: element.id, address: element.address, latitude: element.latitude, longitude: element.longitude)
                    }
                    
                    if (self?.currentLocation != nil && self?.destinationLocation != nil) {
                        self?.goToConfirmTripPage()
                    }
                }
            }
            
            return cell
        }.disposed(by: disposeBag)
    }
    
    func selectDestinationFromMap() {
        let storyboard = UIStoryboard(name: "DestinationFromMap", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "destinationFromMapVC") as! DestinationFromMapViewController
        controller.currentLocation = currentLocation
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func goToConfirmTripPage() {
        let storyboard = UIStoryboard(name: "TripConfirmation", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "tripConfirmationVC") as! TripConfirmationViewController
        controller.tripInformation = TripInformation(from: currentLocation, to: destinationLocation)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { [weak self] response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            self?.currentLocation = DestinationSearchQuery(id: nil, address: lines.joined(separator: "\n"), latitude: coordinate.latitude, longitude: coordinate.longitude)
            self?.sourceLocationField.text = self?.currentLocation.address
            
            UIView.animate(withDuration: 0.25) {
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func prepareForUnwind(_ segue: UIStoryboardSegue) { }

}

extension SearchDestinationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse || status == .authorizedAlways  else {
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        locationManager.stopUpdatingLocation()
    }
}

extension SearchDestinationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 0 {
            self.currentLocation = nil
        } else {
            self.destinationLocation = nil
        }
        
        return true
    }
}
