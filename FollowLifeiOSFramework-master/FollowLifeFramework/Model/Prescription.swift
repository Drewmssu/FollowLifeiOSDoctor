//
//  Prescription.swift
//  FollowLife
//
//  Created by Hugo Andres on 23/05/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Prescription {
    public var id: Int
    public var doctorId: Int
    public var patientId: Int
    public var createdAt: String
    private let dateFormatter: DateFormatter
    
    public init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = 0
        self.doctorId = 0
        self.patientId = 0
        self.createdAt = dateFormatter.string(from: Date())
    }
    
    public init(id: Int, doctorId: Int, patientId: Int, createdAt: Date) {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = id
        self.doctorId = doctorId
        self.patientId = patientId
        self.createdAt = dateFormatter.string(from: createdAt)
    }
    
    public init(id: Int, doctorId: Int, patientId: Int, createdAt: String) {
        self.dateFormatter = DateFormatter()
        
        self.id = id
        self.doctorId = doctorId
        self.patientId = patientId
        self.createdAt = createdAt
    }
    
    public init(from jsonObject: JSON){
        self.dateFormatter = DateFormatter()
        
        self.id = jsonObject["id"].intValue
        self.doctorId = jsonObject["doctorId"].intValue
        self.patientId = jsonObject["patientId"].intValue
        self.createdAt = jsonObject["createdAt"].stringValue
    }
    
    public static func buildCollection(fromJSONArray jsonArray: [JSON]) -> [Prescription] {
        var prescription = [Prescription]()
        let count = jsonArray.count
        for i in 0..<count {
            prescription.append(Prescription.init(from: jsonArray[i]))
        }
        return prescription
    }
}
