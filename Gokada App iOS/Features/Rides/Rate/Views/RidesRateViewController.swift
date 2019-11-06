//
//  RideRateViewController.swift
//  Gokada App iOS
//
//  Created by Oladipupo Oluwatobi Hammed on 31/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//


import UIKit
import Kingfisher
import Entities

struct RateVC {
    static var controller: RidesHomeViewController?
    static var currentUser: User? = User(firstName: "Isaac", lastName: "Ngurumun", phoneNumber: "8145421020", profileImage: "https://cdn2.iconfinder.com/data/icons/rcons-user/32/male-circle-512.png", email: "isaac@gokada.ng")
}



class RidesRateViewController: BaseViewController {
    
    var ridesRateViewModel: IRidesRateViewModel?
    @IBOutlet weak var riderNameLabel: UILabel!
    @IBOutlet weak var riderProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    
    var currentRateValue = Int()
    
    override func getViewModel() -> BaseViewModel {
        return ridesRateViewModel as! BaseViewModel
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
  
    override func viewDidLoad() {
         super.viewDidLoad()
        riderProfileImageView.layer.cornerRadius = riderProfileImageView.frame.size.width  /  2
        riderProfileImageView.clipsToBounds = true
        
        if let userImage = RateVC.currentUser?.profileImage {
                
            setImage(imageUrl: userImage)
                  }

        if let name = RateVC.currentUser?.firstName{
            userNameLabel.text = "\(name),"
        } else {
            userNameLabel.text = "Nil Nil"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.retrieveRatingValue(notification:)), name: Notification.Name(rawValue: RateKeys.ratingNameKey), object: nil)
            
    }
    
    @objc func retrieveRatingValue(notification: Notification) {
        currentRateValue = notification.userInfo![RateKeys.currentRating] as! Int

    }
    
    fileprivate func setImage(imageUrl: String) {
        let processor = RoundCornerImageProcessor(cornerRadius: 50)
        riderProfileImageView.kf.indicatorType = .activity
        riderProfileImageView.kf.setImage(
            with: URL(string: imageUrl),
            placeholder: UIImage(named: "profile_image_cc"),
            options: [.transition(.fade(0.2)), .processor(processor)]
            
        )
    }
        
    
    @IBAction func doneButton(_ sender: UIButton) {
        if currentRateValue != 0 {
            ridesRateViewModel?.updateRiderRating(to: String(currentRateValue), comment: commentTextField.text!)
        } else {
            print("I will just resign controller to the home page")
        }
        print(currentRateValue)
    }
    
    
    
}


