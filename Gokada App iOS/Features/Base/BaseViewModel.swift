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
    
    let disposeBag = DisposeBag()
    let isLoading: PublishSubject<Bool> = PublishSubject()
    let alertValue: PublishSubject<AlertValue> = PublishSubject()
    let apiError: PublishSubject<ApiError> = PublishSubject()
    let throwableError: PublishSubject<Error> = PublishSubject()
    
    func viewDidLoad() { }
    
    func viewWillAppear() { }
    
    func viewDidAppear() { }
    
    func viewWillDisappear() { }
    
    func viewDidDisappear() { }
    
}
