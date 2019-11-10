//
//  RideDurationViewController.swift
//  Gokada App iOS
//
//  Created by Oladipupo Oluwatobi Hammed on 08/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import MapKit

class RideDurationViewController: BaseViewController {
    @IBOutlet weak var mapView: MKMapView!
    private var originalPullUpControllerViewSize: CGSize = .init(width: 414.0, height: 116)
    
    func zoom(to location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)

        mapView.setRegion(region, animated: true)
    }
    
}
