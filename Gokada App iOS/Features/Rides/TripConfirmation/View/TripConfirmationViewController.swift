//
//  TripConfirmationViewController.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 02/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit
import Entities

class TripConfirmationViewController: BaseViewController {

    var tripInformation: TripInformation?
    var tripConfirmationViewModel: ITripConfirmationViewModel?
    
    override func getViewModel() -> BaseViewModel {
        return tripConfirmationViewModel as! BaseViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("The Trip information is: \(tripInformation)")
        tripConfirmationViewModel?.saveSearchHistory(query: tripInformation!.destination)
    }
    
    @IBAction func prepareForUnwind(_ segue: UIStoryboardSegue) { }
}
