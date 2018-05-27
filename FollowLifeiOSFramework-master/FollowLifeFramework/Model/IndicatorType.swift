//
//  IndicatorType.swift
//  FollowLife
//
//  Created by Hugo Andres on 23/05/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class IndicatorType {
    public var id: Int
    public var unitOfMeasurementId: Int
    public var name: String
    public var code: String
    
    public init() {
        self.id = 0
        self.unitOfMeasurementId = 0
        self.name = ""
        self.code = ""
    }
    
    public init(id: Int, unitOfMeasurementId: Int, name: String, code: String) {
        self.id = id
        self.unitOfMeasurementId = unitOfMeasurementId
        self.name = name
        self.code = code
    }
    
    public init(from jsonObject: JSON){
        self.id = jsonObject["id"].intValue
        self.unitOfMeasurementId = jsonObject["unitOfMeasurementId"].intValue
        self.name = jsonObject["name"].stringValue
        self.code = jsonObject["code"].stringValue
    }
    
    public static func buildCollection(fromJSONArray jsonArray: [JSON]) -> [IndicatorType] {
        var IndicatorsType = [IndicatorType]()
        let count = jsonArray.count
        for i in 0..<count {
            IndicatorsType.append(IndicatorType.init(from: jsonArray[i]))
        }
        return IndicatorsType
    }
}
