//
//  AuthValidations.swift
//  Gokada App iOSTests
//
//  Created by Emmanuel Okwara on 27/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import XCTest
@testable import Gokada_App_iOS

class AuthValidations: XCTestCase {
    func test_validLogin() {
        // Invalid phone number
        var error = AuthValidation.validLogin("sdfsfre")
        XCTAssertEqual(error, "Please enter a valid Phone Number")
        
        // Valid phone number
        error = AuthValidation.validLogin("+2348128392832")
        XCTAssertTrue(error == nil)
    }
    
    func test_validProfileRegistration() {
        var profileInformation = [String: String]()
        profileInformation["firstName"] = "Emmanuel"
        profileInformation["lastName"] = "Okwara"
        profileInformation["email"] = "test@test.com"
        profileInformation["profileImage"] = "https://picsum.photos/200"
        
        // Valid profile details
        var error = AuthValidation.validProfileRegistration(profileDetails: profileInformation)
        XCTAssertTrue(error == nil)
        
        // No profile image
        profileInformation["profileImage"] = ""
        error = AuthValidation.validProfileRegistration(profileDetails: profileInformation)
        XCTAssertEqual(error, "Profile image is required")
        
        // Invalid email
        profileInformation["email"] = "sdcsd"
        error = AuthValidation.validProfileRegistration(profileDetails: profileInformation)
        XCTAssertEqual(error, "Please enter a valid Email address")
        
        // Invalid last name
        profileInformation["lastName"] = "2223"
        error = AuthValidation.validProfileRegistration(profileDetails: profileInformation)
        XCTAssertEqual(error, "Please enter a valid last name")
        
        // Invalid first name
        profileInformation["firstName"] = "2223"
        error = AuthValidation.validProfileRegistration(profileDetails: profileInformation)
        XCTAssertEqual(error, "Please enter a valid first name")
    }
}
