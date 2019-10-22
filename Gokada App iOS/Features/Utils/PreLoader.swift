//
//  PreLoader.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 22/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Lottie

protocol PreLoader {
    func showLoading()
    func hideLoading()
}

class DefaultPreLoader: PreLoader {
    let loaderAnimationView = AnimationView(name: "gokada_custom_loader")
    let view: UIView
    
    init(on view: UIView) {
        self.view = view
    }
    
    func showLoading() {
        self.view.addSubview(loaderAnimationView)
        loaderAnimationView.loopMode = .loop
        loaderAnimationView.play()
        addConstraints(newView: loaderAnimationView)
    }
    
    func addConstraints(newView: AnimationView) {
        newView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: newView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: newView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: newView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: newView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0))
    }
    
    func hideLoading() {
        UIView.animate(withDuration: 0.3, animations: {
            self.loaderAnimationView.alpha = 0
        }) { (_) in
            self.loaderAnimationView.removeFromSuperview()
        }
    }
}
