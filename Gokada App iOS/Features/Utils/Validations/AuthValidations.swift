//
//  AuthValidations.swift
//  Gokada App iOS
//
//  Created by Emmanuel Okwara on 25/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//

import Foundation

class AuthValidation {
    private static func validEmail(email: String?) -> String? {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailTest.evaluate(with: email?.trimmingCharacters(in: .whitespacesAndNewlines)) {
            return "Please enter a valid Email address"
        }
        return nil
    }
    
    private static func validPhoneNumber(phone: String) -> String? {
        let phoneRegex = "[+][0-9]{13}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        if !phoneTest.evaluate(with: phone.trimmingCharacters(in: .whitespacesAndNewlines)) {
            return "Please enter a valid Phone Number"
        }
        return nil
    }
    
    private static func validName(name: String?, type: String) -> String? {
        let nameRegex = "[A-Za-z ]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        if !emailTest.evaluate(with: name?.trimmingCharacters(in: .whitespacesAndNewlines)) {
            return "Please enter a valid \(type) name"
        }
        return nil
    }
    
    private static func requiredValue(text: String?, type: String) -> String? {
        if text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return "\(type) is required"
        }
        return nil
    }
    
    public static func validLogin(_ phoneNumber: String) -> String? {
        if let phoneError = validPhoneNumber(phone: phoneNumber) {
            return phoneError
        }
        return nil
    }
    
    public static func isValidUserProfileDetails(profileDetails: [String: String]) -> String? {
        if let nameError = validName(name: profileDetails[AuthRequestKeyConstants.FIRST_NAME_KEY], type: "first") {
            return nameError
        } else if let nameError = validName(name: profileDetails[AuthRequestKeyConstants.LAST_NAME_KEY], type: "last") {
            return nameError
        } else if let emailError = validEmail(email: profileDetails[AuthRequestKeyConstants.EMAIL_ADDRESS_KEY]) {
            return emailError
        }
        
        return nil
    }
}
