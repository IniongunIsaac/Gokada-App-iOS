//
//  ProfileItemTableViewCell.swift
//  Gokada App iOS
//
//  Created by Isaac Iniongun on 25/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit
import Entities

class ProfileItemTableViewCell: UITableViewCell {

    @IBOutlet weak var profileItemImageView: UIImageView!
    @IBOutlet weak var profileItemLabel: UILabel!
    
    public var profileItem: ProfileItem! {
        didSet {
            self.profileItemImageView.image = UIImage(named: profileItem.itemImageName)
            self.profileItemLabel.text = profileItem.itemName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
