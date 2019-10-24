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
import Local_Storage

extension SwinjectStoryboard {
    public static func setup() {
        
        defaultContainer.register(IAuthRemote.self) { _ in AuthRemoteImpl() }
        
        defaultContainer.register(IAuthLocal.self) { _ in AuthLocalImpl() }
        
        defaultContainer.register(IAuthRepo.self) { res in
            AuthRepoImpl(authRemote: res.resolve(IAuthRemote.self)!, authLocal: res.resolve(IAuthLocal.self)!)
        }
        
        defaultContainer.register(IWelcomeViewModel.self) { res in
            WelcomeViewModel(authRepo: res.resolve(IAuthRepo.self)!)
        }
        
        defaultContainer.register(ILoginViewModel.self) { res in
            LoginViewModel(authRepo: res.resolve(IAuthRepo.self)!)
        }
        
        defaultContainer.register(IOTPViewModel.self) { res in
            OTPViewModel(authRepo: res.resolve(IAuthRepo.self)!)
        }
        
        defaultContainer.register(IRegisterViewModel.self) { res in
            RegisterViewModel(authRepo: res.resolve(IAuthRepo.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(WelcomeViewController.self) { res, cntrl in
            cntrl.welcomeViewModel = res.resolve(IWelcomeViewModel.self)
        }
        
        defaultContainer.storyboardInitCompleted(LoginViewController.self) { res, cntrl in
            cntrl.authViewModel = res.resolve(ILoginViewModel.self)
        }
        
        defaultContainer.storyboardInitCompleted(OTPViewController.self) { (res, cntrl) in
            cntrl.otpViewModel = res.resolve(IOTPViewModel.self)
        }
        
        defaultContainer.storyboardInitCompleted(RegisterViewController.self) { (res, cntrl) in
            cntrl.registerViewModel = res.resolve(IRegisterViewModel.self)
        }
    }
}
