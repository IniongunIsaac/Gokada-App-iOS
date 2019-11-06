//
//  DestinationFromMapViewController.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 02/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit
import GoogleMaps
import Entities

class DestinationFromMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var closeBtn: UIButton!
    private let locationManager = CLLocationManager()
    @IBOutlet weak var destinationNameLbl: UILabel!
    let geocoder = GMSGeocoder()
    var currentLocation: DestinationSearchQuery!
    var destinationLocation: DestinationSearchQuery!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        closeBtn.dropShadow(color: UIColor.black, opacity: 0.3, offSet: CGSize(width: 0, height: 0), radius: 20, scale: true)
        setupMap()
    }
    
    func setupMap() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager(locationManager, didChangeAuthorization: CLLocationManager.authorizationStatus())
        }
    }
    
    @IBAction func goToConfirmTripPage(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "TripConfirmation", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "tripConfirmationVC") as! TripConfirmationViewController
        controller.tripInformation = TripInformation(from: currentLocation, to: destinationLocation)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func prepareForUnwind(_ segue: UIStoryboardSegue) { }
}

extension DestinationFromMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 10)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        locationManager.stopUpdatingLocation()
    }
}

extension DestinationFromMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            self.destinationNameLbl.text = lines.joined(separator: "\n")
            self.destinationLocation = DestinationSearchQuery(id: nil, address: lines.joined(separator: "\n"), latitude: coordinate.latitude, longitude: coordinate.longitude)
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
