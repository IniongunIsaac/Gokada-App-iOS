//
//  PlacesSuggestionTableViewCell.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 01/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit

class PlacesSuggestionTableViewCell: UITableViewCell {
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    
    func updateView(address: String, icon: UIImage) {
        addressLbl.text = address
        locationImageView.image = icon
    }
}
