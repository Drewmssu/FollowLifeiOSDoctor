//
//  Indicator.swift
//  FollowLife
//
//  Created by Hugo Andres on 23/05/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Indicator {
    public var id: Int
    public var patientId: Int
    public var unitOfMeasurementId: Int
    public var quantity: Float
    public var createdAt: String
    public var indicatorTypeId: Int
    public var frequency: String
    private let dateFormatter: DateFormatter
    
    public init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = 0
        self.patientId = 0
        self.unitOfMeasurementId = 0
        self.quantity = Float("0.0000")!
        self.createdAt = dateFormatter.string(from: Date())
        self.indicatorTypeId = 0
        self.frequency = ""
    }
    
    public init(id: Int, patientId: Int, unitOfMeasurementId: Int, quantity: Float, createdAt: Date, indicatorTypeId: Int, frequency: String) {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = id
        self.patientId = patientId
        self.unitOfMeasurementId = unitOfMeasurementId
        self.quantity = quantity
        self.createdAt = dateFormatter.string(from: createdAt)
        self.indicatorTypeId = indicatorTypeId
        self.frequency = frequency
    }
    
    public init(id: Int, patientId: Int, unitOfMeasurementId: Int, quantity: Float, createdAt: String, indicatorTypeId: Int, frequency: String) {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = id
        self.patientId = patientId
        self.unitOfMeasurementId = unitOfMeasurementId
        self.quantity = quantity
        self.createdAt = createdAt
        self.indicatorTypeId = indicatorTypeId
        self.frequency = frequency
    }
    
    public init(from jsonObject: JSON){
        self.dateFormatter = DateFormatter()
        
        self.id = jsonObject["id"].intValue
        self.patientId = jsonObject["patientId"].intValue
        self.unitOfMeasurementId = jsonObject["unitOfMeasurementId"].intValue
        self.quantity = jsonObject["quantity"].floatValue
        self.createdAt = jsonObject["createdAt"].stringValue
        self.indicatorTypeId = jsonObject["indicatorTypeId"].intValue
        self.frequency = jsonObject["frequency"].stringValue
    }
    
    public static func buildCollection(fromJSONArray jsonArray: [JSON]) -> [Indicator] {
        var indicators = [Indicator]()
        let count = jsonArray.count
        for i in 0..<count {
            indicators.append(Indicator.init(from: jsonArray[i]))
        }
        return indicators
    }
}
