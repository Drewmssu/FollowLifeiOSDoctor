//
//  Appointment.swift
//  FollowLife
//
//  Created by Hugo Andres on 22/05/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Appointment {
    public var id: Int
    public var patientId: Int
    public var doctorId: Int
    public var createdAt: String
    public var appointmentDate: String
    public var canceledAt: String
    public var reason: String
    public var status: String
    public var updatedAt: String
    private let dateFormatter: DateFormatter
    
    public init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = 0
        self.patientId = 0
        self.doctorId = 0
        self.createdAt = dateFormatter.string(from: Date())
        self.appointmentDate = dateFormatter.string(from: Date())
        self.canceledAt = dateFormatter.string(from: Date())
        self.reason = ""
        self.status = ""
        self.updatedAt = dateFormatter.string(from: Date())
    }
    
    public init(id: Int, patientId: Int, doctorId: Int, createdAt: Date, appointmentDate: Date, canceledAt: Date, reason: String, status: String, updatedAt: Date) {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = id
        self.patientId = patientId
        self.doctorId = doctorId
        self.createdAt = dateFormatter.string(from: createdAt)
        self.appointmentDate = dateFormatter.string(from: appointmentDate)
        self.canceledAt = dateFormatter.string(from: canceledAt)
        self.reason = reason
        self.status = status
        self.updatedAt = dateFormatter.string(from: updatedAt)
    }
    
    public init(id: Int, patientId: Int, doctorId: Int, createdAt: String, appointmentDate: String, canceledAt: String, reason: String, status: String, updatedAt: String) {
        self.dateFormatter = DateFormatter()
        
        self.id = id
        self.patientId = patientId
        self.doctorId = doctorId
        self.createdAt = createdAt
        self.appointmentDate = appointmentDate
        self.canceledAt = canceledAt
        self.reason = reason
        self.status = status
        self.updatedAt = updatedAt
    }
    
    public init(from jsonObject: JSON){
        self.dateFormatter = DateFormatter()
        
        self.id = jsonObject["id"].intValue
        self.patientId = jsonObject["patientId"].intValue
        self.doctorId = jsonObject["doctorId"].intValue
        self.createdAt = jsonObject["createdAt"].stringValue
        self.appointmentDate = jsonObject["appointmentDate"].stringValue
        self.canceledAt = jsonObject["canceledAt"].stringValue
        self.reason = jsonObject["reason"].stringValue
        self.status = jsonObject["status"].stringValue
        self.updatedAt = jsonObject["updatedAt"].stringValue
    }
    
    public static func buildCollection(fromJSONArray jsonArray: [JSON]) -> [Appointment] {
        var appointments = [Appointment]()
        let count = jsonArray.count
        for i in 0..<count {
            appointments.append(Appointment.init(from: jsonArray[i]))
        }
        return appointments
    }
}
