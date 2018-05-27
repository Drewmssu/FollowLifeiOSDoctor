//
//  Item.swift
//  FollowLife
//
//  Created by Hugo Andres on 23/05/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Item {
    public var id: Int
    public var prescriptionId: Int
    public var itemTypeId: Int
    public var frequency: String
    public var quantity: Int
    public var durationInDays: Int
    public var description: String
    public var createdAt: String
    private let dateFormatter: DateFormatter
    
    public init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = 0
        self.prescriptionId = 0
        self.itemTypeId = 0
        self.frequency = ""
        self.quantity = 0
        self.durationInDays = 0
        self.description = ""
        self.createdAt = dateFormatter.string(from: Date())
    }
    
    public init(id: Int, prescriptionId: Int, itemTypeId: Int, frequency: String, quantity: Int, durationInDays: Int, description: String, createdAt: Date) {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = id
        self.prescriptionId = prescriptionId
        self.itemTypeId = itemTypeId
        self.frequency = frequency
        self.quantity = quantity
        self.durationInDays = durationInDays
        self.description = description
        self.createdAt = dateFormatter.string(from: createdAt)
    }
    
    public init(id: Int, prescriptionId: Int, itemTypeId: Int, frequency: String, quantity: Int, durationInDays: Int, description: String, createdAt: String) {
        self.dateFormatter = DateFormatter()
        
        self.id = id
        self.prescriptionId = prescriptionId
        self.itemTypeId = itemTypeId
        self.frequency = frequency
        self.quantity = quantity
        self.durationInDays = durationInDays
        self.description = description
        self.createdAt = createdAt
    }
    
    public init(from jsonObject: JSON){
        self.dateFormatter = DateFormatter()
        
        self.id = jsonObject["id"].intValue
        self.prescriptionId = jsonObject["prescriptionId"].intValue
        self.itemTypeId = jsonObject["itemTypeId"].intValue
        self.frequency = jsonObject["frequency"].stringValue
        self.quantity = jsonObject["quantity"].intValue
        self.durationInDays = jsonObject["durationInDays"].intValue
        self.description = jsonObject["description"].stringValue
        self.createdAt = jsonObject["createdAt"].stringValue
    }
    
    public static func buildCollection(fromJSONArray jsonArray: [JSON]) -> [Item] {
        var items = [Item]()
        let count = jsonArray.count
        for i in 0..<count {
            items.append(Item.init(from: jsonArray[i]))
        }
        return items
    }
}
