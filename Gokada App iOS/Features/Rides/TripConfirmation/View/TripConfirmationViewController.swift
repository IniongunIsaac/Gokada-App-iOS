//
//  TripConfirmationViewController.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 02/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit
import Entities
import GoogleMaps
import GooglePlaces
import Alamofire

class TripConfirmationViewController: BaseViewController {

    var tripInformation: TripInformation?
    var tripConfirmationViewModel: ITripConfirmationViewModel?
    @IBOutlet weak var closeBtn: UIButton!
    
    // MARK:- Payment Method Variable Declarations
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var paymentMethodIcon: UIImageView!
    @IBOutlet weak var paymentMethodLbl: UIView!
    @IBOutlet weak var paymentMethodTableView: UITableView!
    @IBOutlet var paymentMethodView: UIView!
    @IBOutlet weak var paymentMethodTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var paymentMethodCloseBtn: UIButton!
    @IBOutlet weak var paymentMethodOverlay: UIView!
    @IBOutlet weak var paymentMethodContentView: UIView!
    
    
    // MARK:- Trip Details Outlets
    @IBOutlet weak var accountNumberLbl: UILabel!
    @IBOutlet weak var promotionsView: UIView!
    @IBOutlet weak var promotionsLbl: UILabel!
    @IBOutlet weak var previousAmountLbl: UILabel!
    @IBOutlet weak var newAmountLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var promotionPreviousAmountView: UIView!
    @IBOutlet weak var promotionPreviousAmountViewWidthConstraint: NSLayoutConstraint!
    
    // MARK:- Map Variables
    @IBOutlet weak var mapView: GMSMapView!
    var rectangle = GMSPolyline()
    var sourceMarker = CustomMarker()
    var destinationMarker = CustomMarker()
    var bounds = GMSCoordinateBounds()
    var ridesEstimations: RideEstimates?
    
    
    
    override func getViewModel() -> BaseViewModel {
        return tripConfirmationViewModel as! BaseViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tripConfirmationViewModel?.saveSearchHistory(query: tripInformation!.destination)
        setupGestures()
        bindViews()
        getMissingCoordinates()
        
        closeBtn.dropShadow(color: UIColor.black, opacity: 0.3, offSet: CGSize(width: 0, height: 0), radius: 20, scale: true)
        
        // TODO make this to be done once when the app is loaded
        tripConfirmationViewModel?.fetchPaymentOptions()
        
        // TODO get promotions if there are any
        promotionsView.alpha = 0
        promotionPreviousAmountView.alpha = 0
        promotionPreviousAmountViewWidthConstraint.constant = 0
    }
    
    @IBAction func requestRide(_ sender: UIButton) {
        tripConfirmationViewModel?.requestRide(source: tripInformation!.source, destination: tripInformation!.destination, estimates: self.ridesEstimations!)
    }
    
    func getMissingCoordinates() {
        tripConfirmationViewModel?.getLocationsCoordinates(tripInformation: tripInformation!)
        
        if tripInformation?.source.latitude != 0 && tripInformation?.destination.latitude != 0 {
            setupMap()
        }
    }
    
    func setupMap() {
        self.tripConfirmationViewModel?.getRideEstimates(source: tripInformation!.source, destination: tripInformation!.destination)
        
        let sourcePosition = CLLocationCoordinate2D(latitude: tripInformation?.source.latitude ?? 0, longitude: tripInformation?.source.longitude ?? 0)
        self.sourceMarker.position = sourcePosition
        
        let destinationPosition = CLLocationCoordinate2D(latitude: tripInformation?.destination.latitude ?? 0, longitude: tripInformation?.destination.longitude ?? 0)
        self.destinationMarker.position = destinationPosition
        
        self.sourceMarker.map = mapView
        self.destinationMarker.map = mapView
        
        self.sourceMarker.updateLabel(labelText: tripInformation?.source.address ?? "", source: true)
        self.destinationMarker.updateLabel(labelText: tripInformation?.destination.address ?? "", source: false)
        
        if let _ = tripInformation?.source.latitude, let _ = tripInformation?.destination.latitude {
            self.mapView.delegate = self
            bounds = bounds.includingCoordinate(sourcePosition)
            bounds = bounds.includingCoordinate(destinationPosition)
            
            let update = GMSCameraUpdate.fit(bounds, withPadding: 150)
            mapView.animate(with: update)
            
            mapView.drawPolygon(from: sourcePosition, to: destinationPosition)
        }
    }
    
    func bindViews() {
        tripConfirmationViewModel?.userPaymentOptions.bind(to: self.paymentMethodTableView.rx.items) { [weak self] (tableView, index, element) in
            
            print("The element is: \(element.accountNumber)")
            if element.type != .other {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTableViewCell") as! PaymentMethodTableViewCell
                cell.updateView(option: element)
                cell.addTapGesture { [weak self] in
                    self?.tripConfirmationViewModel?.updateDefaultPayment(accountNumber: element.accountNumber!)
                    self?.hidePaymentOptions()
                }
                
                if element.current {
                    self?.updateCurrentPaymentMethod(option: element)
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewCardTableViewCell") as! AddNewCardTableViewCell
                
                return cell
            }
        }.disposed(by: disposeBag)
        
        
        tripConfirmationViewModel?.sourceCoordinatesResponse.bind { [weak self] source in
            self?.tripInformation?.source = source
            self?.setupMap()
        }.disposed(by: disposeBag)
        
        tripConfirmationViewModel?.destinationCoordinatesResponse.bind { [weak self] destination in
            self?.tripInformation?.destination = destination
            self?.setupMap()
        }.disposed(by: disposeBag)
        
        tripConfirmationViewModel?.rideEstimationResponse.bind { [weak self] estimations in
            self?.ridesEstimations = estimations
            self?.newAmountLbl.text = "\(estimations.totalsEstimated.totalFrom!) - \(estimations.totalsEstimated.totalTo!)"
            self?.distanceLbl.text = "\(Double(estimations.totalsEstimated.distance! / 1000).rounded(toPlaces: 1)) km / \(Int(ceil(estimations.totalsEstimated.duration! / 60))) min"
        }.disposed(by: disposeBag)
        
        tripConfirmationViewModel?.newRideResponse.bind { [weak self] newRide in
            self?.goToOnGoingRidePage(ride: newRide)
        }.disposed(by: disposeBag)
    }
    
    func goToOnGoingRidePage(ride: RequestRide) {
        print("I will navigate to the page with ride: \(ride)")
    }
    
    func updateCurrentPaymentMethod(option: UserPaymentOptions) {
        accountNumberLbl.text = option.accountNumber
        switch option.type {
            case .cash:
                paymentMethodIcon.image = #imageLiteral(resourceName: "cash-1")
            case .visa:
                paymentMethodIcon.image = #imageLiteral(resourceName: "visa-pay-logo")
            case .master:
                paymentMethodIcon.image = #imageLiteral(resourceName: "visa-pay-logo")
            case .verve:
                paymentMethodIcon.image = #imageLiteral(resourceName: "visa-pay-logo")
            case .other: break
            case .none: break
        }
    }
    
    func setupGestures() {
        
        paymentView.addTapGesture { [weak self] in
            self?.showPaymentOptions()
        }
        
        paymentMethodOverlay.addTapGesture { [weak self] in
            self?.hidePaymentOptions()
        }
        
        paymentMethodCloseBtn.addTapGesture { [weak self] in
            self?.hidePaymentOptions()
        }
    }
    
    func showPaymentOptions() {
        let newView = self.paymentMethodView!
        self.paymentMethodTopConstraint.constant = self.view.frame.height
        
        self.view.addSubview(newView)
        self.paymentMethodView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: newView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: newView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: newView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: newView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0))
        
        UIView.animate(withDuration: 0.3) {
            self.paymentMethodView.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1.6, initialSpringVelocity: 0.4, options: .allowAnimatedContent, animations: {
                self.paymentMethodTopConstraint.constant = 74
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
    func hidePaymentOptions() {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1.6, initialSpringVelocity: 0.4, options: .allowAnimatedContent, animations: {
            self.paymentMethodTopConstraint.constant = self.view.frame.height
            self.view.layoutIfNeeded()
            self.paymentMethodView.alpha = 0
        }) { _ in
            self.paymentMethodView.removeFromSuperview()
        }
    }
    
    @IBAction func prepareForUnwind(_ segue: UIStoryboardSegue) { }
}

extension TripConfirmationViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.performSegue(withIdentifier: "returnToPrevPage", sender: self)
        return true
    }
}
