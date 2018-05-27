//
//  Patient.swift
//  FollowLife
//
//  Created by Hugo Andres on 22/05/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Patient {
    public var id: Int
    public var userId: Int
    public var planId: Int
    public var createdAt: String
    public var status: String
    public var updatedAt: String
    public var age: String
    public var bloodType: String
    public var weight: Float
    public var sex: String
    public var height: Float
    private let dateFormatter: DateFormatter
    
    public init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = 0
        self.userId = 0
        self.planId = 0
        self.createdAt = dateFormatter.string(from: Date())
        self.status = ""
        self.updatedAt = dateFormatter.string(from: Date())
        self.age = ""
        self.bloodType = ""
        self.weight = Float("0.0000")!
        self.sex = ""
        self.height = Float("0.0000")!
    }
    
    public init(id: Int, userId: Int,  planId: Int, createdAt: Date, status: String, updatedAt: Date, age: String, bloodType: String, weight: Float, sex: String, height: Float) {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = id
        self.userId = userId
        self.planId = planId
        self.createdAt = dateFormatter.string(from: createdAt)
        self.status = status
        self.updatedAt = dateFormatter.string(from: updatedAt)
        self.age = age
        self.bloodType = bloodType
        self.weight = weight
        self.sex = sex
        self.height = height
    }
    
    public init(id: Int, userId: Int,  planId: Int, createdAt: String, status: String, updatedAt: String, age: String, bloodType: String, weight: Float, sex: String, height: Float) {
        self.dateFormatter = DateFormatter()
        
        self.id = id
        self.userId = userId
        self.planId = planId
        self.createdAt = createdAt
        self.status = status
        self.updatedAt = updatedAt
        self.age = age
        self.bloodType = bloodType
        self.weight = weight
        self.sex = sex
        self.height = height
    }
    
    public init(from jsonObject: JSON){
        self.dateFormatter = DateFormatter()
        
        self.id = jsonObject["id"].intValue
        self.userId = jsonObject["userId"].intValue
        self.planId = jsonObject["planId"].intValue
        self.createdAt = jsonObject["createdAt"].stringValue
        self.status = jsonObject["status"].stringValue
        self.updatedAt = jsonObject["updatedAt"].stringValue
        self.age = jsonObject["age"].stringValue
        self.bloodType = jsonObject["bloodType"].stringValue
        self.weight = jsonObject["weight"].floatValue
        self.sex = jsonObject["sex"].stringValue
        self.height = jsonObject["height"].floatValue
    }
    
    public static func buildCollection(fromJSONArray jsonArray: [JSON]) -> [Patient] {
        var patients = [Patient]()
        let count = jsonArray.count
        for i in 0..<count {
            patients.append(Patient.init(from: jsonArray[i]))
        }
        return patients
    }
}
