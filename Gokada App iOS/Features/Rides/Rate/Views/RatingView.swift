//
//  RatingView.swift
//  Gokada App iOS
//
//  Created by Oladipupo Oluwatobi Hammed on 01/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

import UIKit



@IBDesignable
public class RatingView: UIView {
    
    
    @IBInspectable public var selectedImage: UIImage? {
        didSet { setNeedsLayout() }
    }
    @IBInspectable public var unselectedImage: UIImage? {
        didSet { setNeedsLayout() }
    }
    @IBInspectable public var maxRating: Int = 5 {
        didSet { setNeedsLayout() }
    }
    @IBInspectable public var currentRating: Int = 0 {
        didSet { update(with: currentRating) }
    }
    @IBInspectable public var interButtonSpace: CGFloat = 3 {
        didSet { setNeedsLayout() }
    }
    
    private var starButtons: [UIButton] = []
    // MARK: - Lifecycle -
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        clear()
        
        addStarButtons(quantity: maxRating)
        updateWidth()
        update(with: currentRating)
        
    }
    
    
    // MARK: - Actions -
    
    @objc private func ratingAction(_ sender: UIButton) {
        guard let buttonIndex = starButtons.firstIndex(of: sender) else { return }
        currentRating = buttonIndex +  1
        update(with: currentRating)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:RateKeys.ratingNameKey   ), object: nil, userInfo: [RateKeys.currentRating : currentRating])
        
    }
    
    func currentValue() -> Int {
        return currentRating
    }

    @objc private func touchAction(_ sender: UIButton) {
        sender.isHighlighted = false
       
    }
    
    // MARK: - Private -
    
    private func clear() {
        starButtons.forEach({ $0.removeFromSuperview() })
        starButtons.removeAll()
        
    }
    
    private func addStarButtons(quantity: Int) {
        let buttonSide = frame.size.height
        
        for index in 0..<quantity {
            let newButton = makeStarButton()
            addSubview(newButton)
            starButtons.append(newButton)
            
            newButton.frame = CGRect(x: CGFloat(index) * (buttonSide + interButtonSpace),
                                     y: 0,
                                     width: buttonSide,
                                     height: buttonSide)
            
        }
    }
    
    private func makeStarButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = isUserInteractionEnabled
        button.adjustsImageWhenDisabled = false
        
        button.setBackgroundImage(selectedImage, for: .selected)
        button.setBackgroundImage(unselectedImage, for: .normal)
        
        button.addTarget(self, action: #selector(ratingAction), for: .touchUpInside)
        button.addTarget(self, action: #selector(touchAction), for: .allTouchEvents)
        
        return button
    }
    
    private func update(with rating: Int) {
        for (index, button) in starButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
    
    private func updateWidth() {
        let totalButtonsSpace = CGFloat(maxRating) * frame.size.height
        let totalInterButtonsSpace = CGFloat(maxRating - 1) * interButtonSpace
        let width = (totalButtonsSpace + totalInterButtonsSpace) - 20
        
        if let widthConstraint = constraints.first(where: { $0.firstAttribute == .width }) {
            widthConstraint.constant = width
        } else {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
}
