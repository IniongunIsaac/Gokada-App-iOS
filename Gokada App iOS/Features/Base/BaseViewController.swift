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
    
    private let disposeBag = DisposeBag()
    
    func getViewModel() -> BaseViewModel {
        preconditionFailure("The subclass BaseViewController must provide a subclass of BaseViewModel")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getViewModel().viewDidLoad()
        
        setObservers()
    }
    
    private func setObservers() {
        observeLoadingState()
        observeErrorState()
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
    
    private func observeErrorState() {
        getViewModel().apiError?.asObservable().bind{ [weak self] apiError in
            self?.showErrorAlert(message: apiError.errors.first?.message ?? "An error occurred while making your request. Please try again!")
        }.disposed(by: disposeBag)
    }
    
    private func showLoading() {
        
    }
    
    private func hideLoading() {
        
    }
    
    private func showErrorAlert(message: String) {
        
    }
    
    private func showSuccessAlert() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) { getViewModel().viewWillAppear() }
    
    override func viewWillDisappear(_ animated: Bool) { getViewModel().viewWillDisappear() }
    
    override func viewDidAppear(_ animated: Bool) { getViewModel().viewDidAppear() }
    
    override func viewDidDisappear(_ animated: Bool) { getViewModel().viewDidDisappear() }

}
