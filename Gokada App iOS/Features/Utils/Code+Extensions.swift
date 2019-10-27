//
//  Code+Extensions.swift
//  Gokada App iOS
//
//  Created by Isaac Iniongun on 27/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

extension Date {
    var milliSeconds: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

func getProfileImageName() -> String {
    return "Profile_Image_iOS_\(Date().milliSeconds)"
}
