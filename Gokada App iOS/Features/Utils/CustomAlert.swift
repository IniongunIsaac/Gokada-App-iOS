//
//  CustomAlert.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 25/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit

enum AlertType {
    case success
    case error
    case info
}

public struct AlertValue {
    let message: String
    let type: AlertType
}

class CustomAlert {
    var messageLbl: UILabel!
    var viewActive = false
    var hideView = true
    let parentView: UIView
    
    init(on parentView: UIView) {
        self.parentView = parentView
    }
    
    func showAlert(text: String, type: AlertType) {
        DispatchQueue.main.async {
            if self.viewActive {
                self.hideView = false
            }
            
            self.viewActive = true
            self.messageLbl?.alpha = 1
            
            if self.messageLbl == nil {
                self.messageLbl = UILabel(frame: CGRect(x: 0, y: -60, width: self.parentView.frame.width, height: 60))
                self.messageLbl.backgroundColor = UIColor.red.withAlphaComponent(0.7)
                self.messageLbl.textColor = UIColor.white
                self.messageLbl.textAlignment = .center
                self.messageLbl.numberOfLines = 4
                self.messageLbl.font = self.messageLbl.font.withSize(13)
                let currentWindow: UIWindow? = UIApplication.shared.keyWindow
                currentWindow?.addSubview(self.messageLbl)
            }
            
            
            //Show the message alert
            if type == .success {
                self.messageLbl.backgroundColor = UIColor.green.withAlphaComponent(1)
                self.messageLbl.textColor = UIColor.darkGray
            } else if type == .error {
                self.messageLbl.backgroundColor = UIColor.red.withAlphaComponent(1)
                self.messageLbl.textColor = UIColor.white
            } else  {
                self.messageLbl.backgroundColor = UIColor.darkGray.withAlphaComponent(1)
                self.messageLbl.textColor = UIColor.white
            }
            
            self.messageLbl.text = "\n\n\(text)\n"
            
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 6, options: [], animations: ({
                self.messageLbl.frame.origin.y = 0
            }), completion: nil)
            
            
            //Hide the message after 2 seconds
            _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(CustomAlert.hideAlert), userInfo: nil, repeats: false)
        }
    }
    
    @objc func hideAlert() {
        if viewActive && hideView { //View is up and should be hidden
            viewActive = false
            hideView = true
            
            //Hide label
            UIView.animate(withDuration: 0.51, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 6, options: [], animations: ({
                self.messageLbl.frame.origin.y = -60
            }), completion: {(true) in
                self.messageLbl?.alpha = 0
            })
        } else {    //Wait another two second and hide view
            hideView = true
            viewActive = true
            _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(CustomAlert.hideAlert), userInfo: nil, repeats: false)
        }
    }
}
