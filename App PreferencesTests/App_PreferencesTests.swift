//
//  App_PreferencesTests.swift
//  App PreferencesTests
//
//  Created by Isaac Iniongun on 21/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import XCTest
@testable import App_Preferences

class App_PreferencesTests: XCTestCase {

    func test_saveAuthorizationHeader() {
        Preference.saveAuthorizationHeader(key: "testKey", value: "This is a test")
        XCTAssertEqual(UserDefaults.standard.string(forKey: "testKey"), "This is a test")
    }
    
    func test_getAuthorizationHeader() {
        Preference.saveAuthorizationHeader(key: "testKey", value: "This is a test")
        XCTAssertEqual(Preference.getAuthorizationHeader(key: "testKey"), "This is a test")
    }

}
