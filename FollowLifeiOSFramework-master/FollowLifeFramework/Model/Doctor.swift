//
//  Doctor.swift
//  FollowLife
//
//  Created by Hugo Andres on 22/05/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Doctor {
    public var id: Int
    public var userId: Int
    public var planId: Int
    public var status: String
    public var createdAt: String
    public var medicIdentification: String
    public var updatedAt: String
    public var addressId: Int
    private let dateFormatter: DateFormatter
    
    public init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = 0
        self.userId = 0
        self.planId = 0
        self.status = ""
        self.createdAt = dateFormatter.string(from: Date())
        self.medicIdentification = ""
        self.updatedAt = dateFormatter.string(from: Date())
        self.addressId = 0
    }
    
    public init(id: Int, userId: Int, planId: Int, status: String, createdAt: Date, medicIdentification: String, updatedAt: Date, addressId: Int) {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = id
        self.userId = userId
        self.planId = planId
        self.status = status
        self.createdAt = dateFormatter.string(from: createdAt)
        self.medicIdentification = medicIdentification
        self.updatedAt = dateFormatter.string(from: updatedAt)
        self.addressId = addressId
    }
    
    public init(id: Int, userId: Int, planId: Int, status: String, createdAt: String, medicIdentification: String, updatedAt: String, addressId: Int) {
        self.dateFormatter = DateFormatter()
        
        self.id = id
        self.userId = userId
        self.planId = planId
        self.status = status
        self.createdAt = createdAt
        self.medicIdentification = medicIdentification
        self.updatedAt = updatedAt
        self.addressId = addressId
    }
    
    public init(from jsonObject: JSON){
        self.dateFormatter = DateFormatter()
        
        self.id = jsonObject["id"].intValue
        self.userId = jsonObject["userId"].intValue
        self.planId = jsonObject["planId"].intValue
        self.status = jsonObject["status"].stringValue
        self.createdAt = jsonObject["createdAt"].stringValue
        self.medicIdentification = jsonObject["medicIdentification"].stringValue
        self.updatedAt = jsonObject["updatedAt"].stringValue
        self.addressId = jsonObject["addressId"].intValue
    }
    
    public static func buildCollection(fromJSONArray jsonArray: [JSON]) -> [Doctor] {
        var doctors = [Doctor]()
        let count = jsonArray.count
        for i in 0..<count {
            doctors.append(Doctor.init(from: jsonArray[i]))
        }
        return doctors
    }
}
