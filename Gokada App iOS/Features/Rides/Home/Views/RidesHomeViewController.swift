//
//  RidesHomeViewController.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 30/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit

struct HomeVC {
    static var controller: RidesHomeViewController?
}

class RidesHomeViewController: BaseViewController {
    
    var ridesHomeViewModel: IRidesHomeViewModel?
    @IBOutlet weak var menuBtnView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var sideNavLeftConstraint: NSLayoutConstraint!
    static var controller: RidesHomeViewController?
    @IBOutlet weak var sideNavView: UIView!
    
    override func getViewModel() -> BaseViewModel {
        return ridesHomeViewModel as! BaseViewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        HomeVC.controller = self
        menuBtnView.dropShadow(color: UIColor.black, opacity: 0.3, offSet: CGSize(width: -1, height: 1), radius: 22.0, scale: true)
        
        menuBtn.addTapGesture { [weak self] in
            self?.showSideNav()
        }
        
        self.sideNavView.alpha = 0
        self.sideNavLeftConstraint.constant = -self.view.frame.width
    }
    
    func hideSideNav() {
        UIView.animate(withDuration: 0.2, animations: {
            self.sideNavLeftConstraint.constant = -self.view.frame.width
            self.view.layoutIfNeeded()
        }) { _ in
            self.sideNavView.alpha = 0
        }
    }
    
    func showSideNav() {
        self.sideNavView.alpha = 1
        UIView.animate(withDuration: 0.3, animations: {
            self.sideNavLeftConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func prepareForUnwind(_ segue: UIStoryboardSegue) { }
    
}
