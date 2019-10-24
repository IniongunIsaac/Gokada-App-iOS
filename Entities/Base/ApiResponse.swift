//
//  ApiResponse.swift
//  Entities
//
//  Created by Isaac Iniongun on 21/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public struct ApiResponse<T: Codable>: Codable {
    public var data: T? = nil
    public var error: ApiError? = nil
}
