//
//  User.swift
//  FollowLife
//
//  Created by Hugo Andres on 22/05/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class User {
    public var id: Int
    public var email: String
    public var password: String
    public var roleId: Int
    public var firstName: String
    public var lastName: String
    public var status: String
    public var phoneNumber: String
    public var profilePicture: String
    public var sessionToken: String
    public var lastIPConnection: String
    public var createdAt: String
    public var updatedOn: String
    private let dateFormatter: DateFormatter
    
    public init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = 0
        self.email = ""
        self.password = ""
        self.roleId = 0
        self.firstName = ""
        self.lastName = ""
        self.status = ""
        self.phoneNumber = ""
        self.profilePicture = ""
        self.sessionToken = ""
        self.lastIPConnection = ""
        self.createdAt = dateFormatter.string(from: Date())
        self.updatedOn = dateFormatter.string(from: Date())
    }
    
    public init(id: Int, email: String, password: String, roleId: Int, firstName: String, lastName: String, status: String, phoneNumber: String, profilePicture: String, sessionToken: String, lastIPConnection: String, createdAt: Date, updatedOn: Date) {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = id
        self.email = email
        self.password = password
        self.roleId = roleId
        self.firstName = firstName
        self.lastName = lastName
        self.status = status
        self.phoneNumber = phoneNumber
        self.profilePicture = profilePicture
        self.sessionToken = sessionToken
        self.lastIPConnection = lastIPConnection
        self.createdAt = dateFormatter.string(from: createdAt)
        self.updatedOn = dateFormatter.string(from: updatedOn)
    }
    
    public init(id: Int, email: String, password: String, roleId: Int, firstName: String, lastName: String, status: String, phoneNumber: String, profilePicture: String, sessionToken: String, lastIPConnection: String, createdAt: String, updatedOn: String) {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = id
        self.email = email
        self.password = password
        self.roleId = roleId
        self.firstName = firstName
        self.lastName = lastName
        self.status = status
        self.phoneNumber = phoneNumber
        self.profilePicture = profilePicture
        self.sessionToken = sessionToken
        self.lastIPConnection = lastIPConnection
        self.createdAt = createdAt
        self.updatedOn = updatedOn
    }
    
    public init(from jsonObject: JSON){
        self.dateFormatter = DateFormatter()
        
        self.id = jsonObject["id"].intValue
        self.email = jsonObject["email"].stringValue
        self.password = jsonObject["password"].stringValue
        self.roleId = jsonObject["roleId"].intValue
        self.firstName = jsonObject["firstName"].stringValue
        self.lastName = jsonObject["lastName"].stringValue
        self.status = jsonObject["status"].stringValue
        self.phoneNumber = jsonObject["phoneNumber"].stringValue
        self.profilePicture = jsonObject["profilePicture"].stringValue
        self.sessionToken = jsonObject["sessionToken"].stringValue
        self.lastIPConnection = jsonObject["lastIPConnection"].stringValue
        self.createdAt = jsonObject["createdAt"].stringValue
        self.updatedOn = jsonObject["updatedOn"].stringValue
    }
    
    public static func buildCollection(fromJSONArray jsonArray: [JSON]) -> [User] {
        var users = [User]()
        let count = jsonArray.count
        for i in 0..<count {
            users.append(User.init(from: jsonArray[i]))
        }
        return users
    }
}
