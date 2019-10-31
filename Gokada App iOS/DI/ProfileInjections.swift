//
//  ProfileInjections.swift
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

class ProfileInjections {
    static func setup(container: Container) {
        container.register(IProfileDetailsViewModel.self) { res in
            ProfileDetailsViewModel(authRepo: res.resolve(IAuthRepo.self)!)
        }
        
        container.register(IEditProfileViewModel.self) { res in
            EditProfileViewModel(authRepo: res.resolve(IAuthRepo.self)!)
        }
        
        container.storyboardInitCompleted(ProfileDetailsViewController.self) { res, cntrl in
            cntrl.profileDetailsViewModel = res.resolve(IProfileDetailsViewModel.self)
        }
        
        container.storyboardInitCompleted(EditProfileViewController.self) { res, cntrl in
            cntrl.editProfileViewModel = res.resolve(IEditProfileViewModel.self)
        }
    }
}
