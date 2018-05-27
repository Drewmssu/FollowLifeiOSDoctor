//
//  Membership.swift
//  FollowLife
//
//  Created by Hugo Andres on 22/05/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Membership {
    public var id: Int
    public var doctorId: Int
    public var patientId: Int
    public var referenceEmail: String
    public var token: String
    public var createdAt: String
    public var expiresAt: String
    public var status: String
    private let dateFormatter: DateFormatter
    
    public init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = 0
        self.doctorId = 0
        self.patientId = 0
        self.referenceEmail = ""
        self.token = ""
        self.createdAt = dateFormatter.string(from: Date())
        self.expiresAt = dateFormatter.string(from: Date())
        self.status = ""
    }
    
    public init(id: Int, doctorId: Int, patientId: Int, referenceEmail: String, token: String, createdAt: Date, expiresAt: Date, status: String) {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = id
        self.doctorId = doctorId
        self.patientId = patientId
        self.referenceEmail = referenceEmail
        self.token = token
        self.createdAt = dateFormatter.string(from: createdAt)
        self.expiresAt = dateFormatter.string(from: expiresAt)
        self.status = status
    }
    
    public init(id: Int, doctorId: Int, patientId: Int, referenceEmail: String, token: String, createdAt: String, expiresAt: String, status: String) {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = id
        self.doctorId = doctorId
        self.patientId = patientId
        self.referenceEmail = referenceEmail
        self.token = token
        self.createdAt = createdAt
        self.expiresAt = expiresAt
        self.status = status
    }
    
    public init(from jsonObject: JSON){
        self.dateFormatter = DateFormatter()
        
        self.id = jsonObject["id"].intValue
        self.doctorId = jsonObject["doctorId"].intValue
        self.patientId = jsonObject["patientId"].intValue
        self.referenceEmail = jsonObject["referenceEmail"].stringValue
        self.token = jsonObject["token"].stringValue
        self.createdAt = jsonObject["createdAt"].stringValue
        self.expiresAt = jsonObject["expiresAt"].stringValue
        self.status = jsonObject["status"].stringValue
    }
    
    public static func buildCollection(fromJSONArray jsonArray: [JSON]) -> [Membership] {
        var memberships = [Membership]()
        let count = jsonArray.count
        for i in 0..<count {
            memberships.append(Membership.init(from: jsonArray[i]))
        }
        return memberships
    }
}
