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

extension SwinjectStoryboard {
    public static func setup() {
        RidesInjections.setup(container: defaultContainer)
        AuthInjections.setup(container: defaultContainer)
        ProfileInjections.setup(container: defaultContainer)
    }
}
