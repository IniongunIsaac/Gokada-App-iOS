//
//  RidesHomeViewController.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 30/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit

class RidesHomeViewController: BaseViewController {
    
    var ridesHomeViewModel: IRidesHomeViewModel?
    @IBOutlet weak var menuBtnView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    
    override func getViewModel() -> BaseViewModel {
        return ridesHomeViewModel as! BaseViewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtnView.dropShadow(color: UIColor.black, opacity: 0.3, offSet: CGSize(width: -1, height: 1), radius: 22.0, scale: true)
        
        menuBtn.addTapGesture { [weak self] in
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "profileNavigationVC")
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func prepareForUnwind(_ segue: UIStoryboardSegue) { }
    
}
