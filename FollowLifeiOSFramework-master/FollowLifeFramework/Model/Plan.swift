//
//  Plan.swift
//  FollowLife
//
//  Created by Hugo Andres on 23/05/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Plan {
    public var id: Int
    public var code: String
    public var name: String
    public var description: String
    public var acceptedPatients: Int
    public var price: Float
    
    public init() {
        self.id = 0
        self.code = ""
        self.name = ""
        self.description = ""
        self.acceptedPatients = 0
        self.price = Float("0.0000")!
    }
    
    public init(id: Int, code: String, name: String, description: String, acceptedPatients: Int, price: Float) {
        self.id = id
        self.code = code
        self.name = name
        self.description = description
        self.acceptedPatients = acceptedPatients
        self.price = price
    }
    
    public init(from jsonObject: JSON){
        self.id = jsonObject["id"].intValue
        self.code = jsonObject["code"].stringValue
        self.name = jsonObject["name"].stringValue
        self.description = jsonObject["description"].stringValue
        self.acceptedPatients = jsonObject["acceptedPatients"].intValue
        self.price = jsonObject["price"].floatValue
    }
    
    public static func buildCollection(fromJSONArray jsonArray: [JSON]) -> [Plan] {
        var plans = [Plan]()
        let count = jsonArray.count
        for i in 0..<count {
            plans.append(Plan.init(from: jsonArray[i]))
        }
        return plans
    }
}
