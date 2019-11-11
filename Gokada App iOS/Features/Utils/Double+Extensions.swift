//
//  Double+Extensions.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 09/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
