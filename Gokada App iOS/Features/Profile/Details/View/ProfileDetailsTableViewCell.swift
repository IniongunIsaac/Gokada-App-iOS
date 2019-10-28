//
//  ProfileDetailsTableViewCell.swift
//  Gokada App iOS
//
//  Created by Isaac Iniongun on 28/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit
import Entities
import Kingfisher

class ProfileDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: ImageViewWithBorderAttributes!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editProfileButton: ButtonWithBorderAttributes!
    
    var user: User! {
        
        didSet {
            if let userImage = user?.profileImage {
                setImage(imageUrl: userImage)
            }

            if let fname = user?.firstName, let lname = user?.lastName {
                fullNameLabel.text = "\(fname) \(lname)"
            } else {
                fullNameLabel.text = "Nil Nil"
            }

            if let email = user?.email {
                emailLabel.text = email
            }
        }
        
    }
    
    fileprivate func setImage(imageUrl: String) {
        let processor = RoundCornerImageProcessor(cornerRadius: 50)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(
            with: URL(string: imageUrl),
            placeholder: UIImage(named: "profile_image_icon"),
            options: [.transition(.fade(0.2)), .processor(processor)]
        )
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
