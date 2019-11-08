//
//  EstimatedFare.swift
//  Gokada App iOS
//
//  Created by Oladipupo Oluwatobi Hammed on 08/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import PullUpController
import UIKit

class EstimatedFare: PullUpController{
    
    enum InitialState {
        case contracted
        case expanded
    }
    
    var initialState: InitialState = .contracted
    
    
}
