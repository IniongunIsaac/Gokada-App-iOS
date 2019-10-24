//
//  User.swift
//  Entities
//
//  Created by Isaac Iniongun on 21/10/2019.
//  Copyright © 2019 Gokada. All rights reserved.
//
import Foundation
import RealmSwift

@objcMembers public class User: Object, Codable {
    public dynamic var id: String = ""
    public dynamic var firstName: String? = nil
    public dynamic var lastName: String? = nil
    public dynamic var phoneNumber: String? = nil
    public dynamic var driver: Pilot?
    public dynamic var profileImage: String? = nil
    public dynamic var email: String? = nil
    public var roles = List<String>()
    
    override public static func ignoredProperties() -> [String] {
        return ["driver"]
    }
    
    public override class func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey{
        case id, firstName, lastName, phoneNumber, driver, roles, profileImage, email
    }
    
    public convenience required init(firstName: String, lastName: String, phoneNumber: String, profileImage: String, email: String) {
        self.init()
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.profileImage = profileImage
        self.email = email
    }
    
    public required convenience init(decoder: Decoder) throws {
        self.init()
        
        //Get the root of our object
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //Decode id from container(the root)
        id = try container.decode(String.self, forKey: .id)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        driver = try container.decodeIfPresent(Pilot.self, forKey: .driver)
        let rolesList = try container.decodeIfPresent([String].self, forKey: .roles) ?? [String]()
        roles.append(objectsIn: rolesList)
        profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        
    }
    
}
