//
//  RidesInjections.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 30/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import Repository
import Remote_API
import Local_Storage

class RidesInjections {
    static func setup(container: Container) {
        container.register(IRidesRemote.self) { _ in RidesRemoteImpl() }
        container.register(IRidesLocal.self) { _ in RidesLocalImpl() }
        container.register(IRidesRepo.self) { res in
            RidesRepoImpl(ridesRemote: res.resolve(IRidesRemote.self)!, ridesLocal: res.resolve(IRidesLocal.self)!)
        }
        container.register(IRidesHomeViewModel.self) { res in
            RidesHomeViewModel(ridesRepo: res.resolve(IRidesRepo.self)!)
        }
        
        container.storyboardInitCompleted(RidesHomeViewController.self) { (res, cntrl) in
            cntrl.ridesHomeViewModel = res.resolve(IRidesHomeViewModel.self)
        }
    }
}
