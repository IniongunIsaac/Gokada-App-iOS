//
//  GMSMarker.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 08/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import GoogleMaps

class CustomMarker: GMSMarker {

    var label: UILabel!

    func updateLabel(labelText: String, source: Bool) {
        let iconView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 150, height: 30)))
        iconView.backgroundColor = .white

        label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: iconView.bounds.width, height: 30)))
        label.text = "  \(labelText)"
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 5
        label.font = label.font.withSize(12)
        label.clipsToBounds = true
        
        if source {
            label.layer.borderColor = UIColor.green.cgColor
        } else {
            label.layer.borderColor = UIColor(displayP3Red: 0/255, green: 99/255, blue: 199/255, alpha: 1).cgColor
        }
        
        
        iconView.addSubview(label)

        self.iconView = iconView
    }
}
