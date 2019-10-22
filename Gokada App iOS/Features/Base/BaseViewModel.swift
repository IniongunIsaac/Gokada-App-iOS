//
//  BaseViewModel.swift
//  Gokada App iOS
//
//  Created by Isaac Iniongun on 22/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import RxSwift
import Entities

class BaseViewModel {
    
    private let disposable = DisposeBag()
    let isLoading: Single<Bool> = Single.just(false)
    let apiError: Single<ApiError>? = nil
    
    func viewDidLoad() { }
    
    func viewWillAppear() { }
    
    func viewDidAppear() { }
    
    func viewWillDisappear() { }
    
    func viewDidDisappear() { }
    
}
