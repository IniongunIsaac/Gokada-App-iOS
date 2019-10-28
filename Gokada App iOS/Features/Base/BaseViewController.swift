//
//  BaseViewController.swift
//  Gokada App iOS
//
//  Created by Isaac Iniongun on 22/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    
    public let disposeBag = DisposeBag()
    fileprivate var preloader: PreLoader!
    fileprivate var alert: CustomAlert?
    
    fileprivate var scrollViewConstraint: NSLayoutConstraint?
    
    var keyboardHeight: CGFloat = 0.0
    
    func getViewModel() -> BaseViewModel {
        preconditionFailure("The subclass BaseViewController must provide a subclass of BaseViewModel")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getViewModel().viewDidLoad()
        
        setObservers()
        self.preloader = DefaultPreLoader(on: self.view)
        self.alert = CustomAlert(on: self.view)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        //addScrollViewListener()
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
        expandScrollView()
    }
    
    func addScrollViewListener(constraint: NSLayoutConstraint) {
        self.scrollViewConstraint = constraint
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 6, options: [], animations: ({
                if keyboardRectangle.origin.y >= self.view.frame.height {
                    self.scrollViewConstraint?.constant = 0
                } else {
                    self.scrollViewConstraint?.constant = self.keyboardHeight
                }
                self.view.layoutIfNeeded()
            }), completion: nil)
        }
    }
    
    func expandScrollView() {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 6, options: [], animations: ({
            self.scrollViewConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }), completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyboard()
    }
    
    private func setObservers() {
        observeLoadingState()
        observeApiErrorState()
        observeThrowableErrorState()
        observeAlerts()
    }
    
    private func observeAlerts() {
        getViewModel().alertValue.asObservable().bind { [weak self] value in
            self?.showAlert(message: value.message, type: value.type)
        }.disposed(by: disposeBag)
    }
    
    private func observeLoadingState() {
        getViewModel().isLoading.asObservable().bind { [weak self] value in
            if value {
                self?.showLoading()
            } else {
                self?.hideLoading()
            }
        }.disposed(by: disposeBag)
    }
    
    private func observeApiErrorState() {
        getViewModel().apiError.asObservable().bind{ [weak self] apiError in
            self?.showAlert(message: apiError.errors.first?.message ?? "An error occurred while making your request. Please try again!", type: .error)
        }.disposed(by: disposeBag)
    }
    
    private func observeThrowableErrorState() {
        getViewModel().throwableError.asObserver().bind { [weak self] error in
            self?.showAlert(message: error.localizedDescription, type: .error)
        }.disposed(by: disposeBag)
    }
    
    private func showLoading() {
        self.preloader.showLoading()
    }
    
    private func hideLoading() {
        self.preloader.hideLoading()
    }
    
    private func showAlert(message: String, type: AlertType) {
        self.alert?.showAlert(text: message, type: type)
    }
    
    override func viewWillAppear(_ animated: Bool) { getViewModel().viewWillAppear() }
    
    override func viewWillDisappear(_ animated: Bool) { getViewModel().viewWillDisappear() }
    
    override func viewDidAppear(_ animated: Bool) { getViewModel().viewDidAppear() }
    
    override func viewDidDisappear(_ animated: Bool) { getViewModel().viewDidDisappear() }

}
