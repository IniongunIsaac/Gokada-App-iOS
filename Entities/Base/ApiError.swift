//
//  ApiError.swift
//  Entities
//
//  Created by Isaac Iniongun on 21/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public struct ApiError: Codable {
    public let errors: [ErrorMessage]
    public let statusCode: CLong
}
