//
//  AuthInjections.swift
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

class AuthInjections {
    static func setup(container: Container) {
        container.register(IAuthRemote.self) { _ in AuthRemoteImpl() }
        
        container.register(IAuthLocal.self) { _ in AuthLocalImpl() }
        
        container.register(IAuthRepo.self) { res in
            AuthRepoImpl(authRemote: res.resolve(IAuthRemote.self)!, authLocal: res.resolve(IAuthLocal.self)!)
        }
        
        container.register(IWelcomeViewModel.self) { res in
            WelcomeViewModel(authRepo: res.resolve(IAuthRepo.self)!)
        }
        
        container.register(ILoginViewModel.self) { res in
            LoginViewModel(authRepo: res.resolve(IAuthRepo.self)!)
        }
        
        container.register(IOTPViewModel.self) { res in
            OTPViewModel(authRepo: res.resolve(IAuthRepo.self)!)
        }
        
        container.register(IRegisterViewModel.self) { res in
            RegisterViewModel(authRepo: res.resolve(IAuthRepo.self)!)
        }
        
        container.storyboardInitCompleted(WelcomeViewController.self) { res, cntrl in
            cntrl.welcomeViewModel = res.resolve(IWelcomeViewModel.self)
        }
        
        container.storyboardInitCompleted(LoginViewController.self) { res, cntrl in
            cntrl.authViewModel = res.resolve(ILoginViewModel.self)
        }
        
        container.storyboardInitCompleted(OTPViewController.self) { (res, cntrl) in
            cntrl.otpViewModel = res.resolve(IOTPViewModel.self)
        }
        
        container.storyboardInitCompleted(RegisterViewController.self) { (res, cntrl) in
            cntrl.registerViewModel = res.resolve(IRegisterViewModel.self)
        }
    }
}
