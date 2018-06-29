//
//  Item.swift
//  FollowLife
//
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Prescription {
    public var id: Int
    public var doctorId: Int
    public var prescriptionTypeId: PrescriptionType
    public var frequency: String
    public var quantity: Int
    public var durationInDays: Int
    public var description: String
    public var patientId: Int
    public var startedAt: String
    public var finishedAt: String
    public var status: String
    
    public init() {
        self.id = 0
        self.doctorId = 0
        self.prescriptionTypeId = PrescriptionType.init()
        self.frequency = ""
        self.quantity = 0
        self.durationInDays = 0
        self.description = ""
        self.patientId = 0
        self.startedAt = Utils.getTimeNow()
        self.finishedAt = Utils.getTimeNow()
        self.status = ""
    }
    
    public init(id: Int, doctorId: Int, prescriptionTypeId: PrescriptionType?, frequency: String?, quantity: Int?, durationInDays: Int?, description: String?, patientId: Int, startedAt: Date, finishedAt: Date?, status: String?) {
        self.id = id
        self.doctorId = 0
        self.prescriptionTypeId = (prescriptionTypeId == nil) ? PrescriptionType.init() : prescriptionTypeId!
        self.frequency = (frequency == nil) ? "" : frequency!
        self.quantity = (quantity == nil) ? 0 : quantity!
        self.durationInDays = (durationInDays == nil) ? 0 : durationInDays!
        self.description = (description == nil) ? "" : description!
        self.startedAt = Utils.convertTime(from: startedAt)
        self.patientId = 0
        self.finishedAt = (finishedAt == nil) ? Utils.getTimeNow() : Utils.convertTime(from: finishedAt)
        self.status = (status == nil) ? "" : status!
    }
    
    
    public init(id: Int, doctorId: Int, prescriptionTypeId: PrescriptionType?, frequency: String?, quantity: Int?, durationInDays: Int?, description: String?, patientId: Int, startedAt: String, finishedAt: String?, status: String?) {
        self.id = id
        self.doctorId = 0
        self.prescriptionTypeId = (prescriptionTypeId == nil) ? PrescriptionType.init() : prescriptionTypeId!
        self.frequency = (frequency == nil) ? "" : frequency!
        self.quantity = (quantity == nil) ? 0 : quantity!
        self.durationInDays = (durationInDays == nil) ? 0 : durationInDays!
        self.description = (description == nil) ? "" : description!
        self.startedAt = startedAt
        self.patientId = 0
        self.finishedAt = (finishedAt == nil) ? Utils.getTimeNow() : finishedAt!
        self.status = (status == nil) ? "" : status!
    }
    
    public convenience init(from jsonObject: JSON) {
        self.init(id: jsonObject["id"].intValue,
                  doctorId: jsonObject["doctorId"].intValue,
                  prescriptionTypeId: PrescriptionType.init(from: jsonObject["prescriptionType"]),
                  frequency: jsonObject["frequency"].stringValue,
                  quantity: jsonObject["quantity"].intValue,
                  durationInDays: jsonObject["durationInDays"].intValue,
                  description: jsonObject["description"].stringValue,
                  patientId: jsonObject["patientId"].intValue,
                  startedAt: jsonObject["startedAt"].stringValue,
                  finishedAt: jsonObject["finishedAt"].stringValue,
                  status: jsonObject["status"].stringValue)
    }
    
    public static func buildCollection(fromJSONArray jsonArray: [JSON]) -> [Prescription] {
        var items = [Prescription]()
        let count = jsonArray.count
        for i in 0..<count {
            items.append(Prescription.init(from: jsonArray[i]))
        }
        return items
    }
}
