//
//  AuthInjections.swift
//  Gokada App iOS
//
//  Created by Isaac Iniongun on 22/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import Repository
import Remote_API

extension SwinjectStoryboard {
    public static func setup() {
        
        defaultContainer.register(IAuthRemote.self) { _ in AuthRemoteImpl() }
        
        defaultContainer.register(IAuthRepo.self) { res in
            AuthRepoImpl(authRemote: res.resolve(IAuthRemote.self)!)
        }
        
        defaultContainer.register(IAuthViewModel.self) { res in
            AuthViewModel(authRepo: res.resolve(IAuthRepo.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(LoginViewController.self) { res, cntrl in
            cntrl.authViewModel = res.resolve(IAuthViewModel.self)
        }
    }
}
