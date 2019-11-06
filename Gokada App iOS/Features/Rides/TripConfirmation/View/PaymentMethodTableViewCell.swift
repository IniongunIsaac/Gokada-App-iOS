//
//  PaymentMethodTableViewCell.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 06/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit
import Entities

class PaymentMethodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var methodTypeImageView: UIImageView!
    @IBOutlet weak var cardNumberLbl: UILabel!
    @IBOutlet weak var currentSelectionView: UIImageView!
    
    
    func updateView(option: UserPaymentOptions) {
        cardNumberLbl.text = option.accountNumber
        
        if option.current {
            currentSelectionView.alpha = 1
        } else {
            currentSelectionView.alpha = 0
        }
        
        switch option.type {
            case .cash:
                methodTypeImageView.image = #imageLiteral(resourceName: "cash-1")
            case .visa:
                methodTypeImageView.image = #imageLiteral(resourceName: "visa-pay-logo")
            case .master:
                methodTypeImageView.image = #imageLiteral(resourceName: "visa-pay-logo")
            case .verve:
                methodTypeImageView.image = #imageLiteral(resourceName: "visa-pay-logo")
            case .other: break
            case .none: break
        }
    }
}
