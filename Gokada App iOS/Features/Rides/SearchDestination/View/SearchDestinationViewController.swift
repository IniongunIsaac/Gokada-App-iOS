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
        searchDestinationViewModel?.placesSuggestion.bind(to: self.suggestionTableView.rx.items) { (tableView, index, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlacesSuggestionTableViewCell") as! PlacesSuggestionTableViewCell
            
            if index == 0 {
                cell.updateView(address: element, icon: #imageLiteral(resourceName: "onlineIcon"))
                cell.addTapGesture { [weak self] in
                    self?.selectDestinationFromMap()
                }
            } else {
                cell.updateView(address: element, icon: #imageLiteral(resourceName: "maps-and-flags"))
                cell.addTapGesture { [weak self] in
                    self?.populateSuggestedPlace(element)
                    if self?.sourceLocationField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && self?.destinationLocationField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
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
        controller.currentLocation = sourceLocationField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func goToConfirmTripPage() {
        let storyboard = UIStoryboard(name: "TripConfirmation", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "tripConfirmationVC") as! TripConfirmationViewController
        controller.tripInformation = TripInformation(from: sourceLocationField.text!.trimmingCharacters(in: .whitespacesAndNewlines), to: destinationLocationField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func populateSuggestedPlace(_ suggestion: String) {
        self.currentSearchField?.text = suggestion
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            self.sourceLocationField.text = lines.joined(separator: "\n")
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
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
