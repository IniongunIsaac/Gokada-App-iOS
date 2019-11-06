//
//  RidesHomeViewController.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 30/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit
import Entities
import GoogleMaps

struct HomeVC {
    static var controller: RidesHomeViewController?
    static var currentUser: User?
}

class RidesHomeViewController: BaseViewController {
    
    var ridesHomeViewModel: IRidesHomeViewModel?
    @IBOutlet weak var menuBtnView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var sideNavLeftConstraint: NSLayoutConstraint!
    static var controller: RidesHomeViewController?
    @IBOutlet weak var sideNavView: UIView!
    @IBOutlet weak var selectDestinationView: UIView!
    @IBOutlet weak var searchHistoryTableView: UITableView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    var currentLocation: String?
    
    override func getViewModel() -> BaseViewModel {
        return ridesHomeViewModel as! BaseViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HomeVC.controller = self
        menuBtn.addTapGesture { [weak self] in
            self?.showSideNav()
        }
        configureUI()
        bindViews()
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
    
    func populateUI() {
        userNameLbl.text = HomeVC.currentUser?.firstName
        ridesHomeViewModel?.getDestinationSearchHistory()
    }
    
    func bindViews() {
        ridesHomeViewModel?.searchHistory.bind(to: self.searchHistoryTableView.rx.items) { (tableView, index, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchHistoryTableViewCell") as! SearchHistoryTableViewCell
            cell.updateView(query: element)
            
            cell.addTapGesture { [weak self] in
                if let sourceAddress = self?.currentLocation {
                    let storyboard = UIStoryboard(name: "TripConfirmation", bundle: nil)
                    let controller = storyboard.instantiateViewController(identifier: "tripConfirmationVC") as! TripConfirmationViewController
                    controller.tripInformation = TripInformation(from: sourceAddress, to: element)
                    self?.navigationController?.pushViewController(controller, animated: true)
                }
            }
            
            return cell
        }.disposed(by: disposeBag)
        
        selectDestinationView.addTapGesture { [weak self] in
            let storyboard = UIStoryboard(name: "RidesSelectDestination", bundle: nil)
            let controller = storyboard.instantiateViewController(identifier: "searchDestinationVC") as! SearchDestinationViewController
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func configureUI() {
        menuBtnView.dropShadow(color: UIColor.black, opacity: 0.3, offSet: CGSize(width: -1, height: 1), radius: 22.0, scale: true)
        self.sideNavView.alpha = 0
        self.sideNavLeftConstraint.constant = -self.view.frame.width
        selectDestinationView.dropShadow(color: UIColor.black, opacity: 0.1, offSet: CGSize(width: 0, height: 0), radius: 22.0, scale: true)
    }
    
    func hideSideNav() {
        UIView.animate(withDuration: 0.2, animations: {
            self.sideNavLeftConstraint.constant = -self.view.frame.width
            self.view.layoutIfNeeded()
        }) { _ in
            self.sideNavView.alpha = 0
        }
    }
    
    func showSideNav() {
        self.sideNavView.alpha = 1
        UIView.animate(withDuration: 0.3, animations: {
            self.sideNavLeftConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateUI()
    }
    
    @IBAction func prepareForUnwind(_ segue: UIStoryboardSegue) { }
    
}

extension RidesHomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse || status == .authorizedAlways  else {
            return
        }
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        locationManager.stopUpdatingLocation()
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            self.currentLocation = lines.joined(separator: "\n")
        }
    }
}
