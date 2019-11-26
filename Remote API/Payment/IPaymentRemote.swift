//
//  IPaymentRemote.swift
//  Remote API
//
//  Created by Isaac Iniongun on 18/11/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import RxSwift
import Entities

public protocol IPaymentRemote {
    func addCard(requestBody: [String : String])
}
