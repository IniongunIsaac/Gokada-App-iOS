//
//  Preference.swift
//  App Preferences
//
//  Created by Isaac Iniongun on 22/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

public struct Preference {
    
    public static func getAuthorizationHeader(key: String = PreferenceConstants.AUTHORIZATION_HEADER_KEY) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    public static func saveAuthorizationHeader(key: String = PreferenceConstants.AUTHORIZATION_HEADER_KEY, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    public static func getUserLoginStatus(key: String = PreferenceConstants.USER_LOGIN_STATUS_KEY) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    public static func saveUserLoginStatus(key: String = PreferenceConstants.USER_LOGIN_STATUS_KEY, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
}
