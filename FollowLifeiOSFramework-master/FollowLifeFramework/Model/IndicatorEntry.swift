//
//  IndicatorEntry.swift
//  FollowLife
//
//  Created by Hugo Andres on 23/05/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class IndicatorEntry {
    public var id: Int
    public var indicatorId: Int
    public var value: String
    public var createdAt: String
    private let dateFormatter: DateFormatter
    
    public init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = 0
        self.indicatorId = 0
        self.value = ""
        self.createdAt = dateFormatter.string(from: Date())
    }
    
    public init(id: Int, indicatorId: Int, value: String, createdAt: Date) {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = id
        self.indicatorId = indicatorId
        self.value = value
        self.createdAt = dateFormatter.string(from: createdAt)
    }
    
    public init(id: Int, indicatorId: Int, value: String, createdAt: String) {
        self.dateFormatter = DateFormatter()
        
        self.id = id
        self.indicatorId = indicatorId
        self.value = value
        self.createdAt = createdAt
    }
    
    public init(from jsonObject: JSON){
        self.dateFormatter = DateFormatter()
        
        self.id = jsonObject["id"].intValue
        self.indicatorId = jsonObject["indicatorId"].intValue
        self.value = jsonObject["value"].stringValue
        self.createdAt = jsonObject["createdAt"].stringValue
    }
    
    public static func buildCollection(fromJSONArray jsonArray: [JSON]) -> [IndicatorEntry] {
        var indicatorEntries = [IndicatorEntry]()
        let count = jsonArray.count
        for i in 0..<count {
            indicatorEntries.append(IndicatorEntry.init(from: jsonArray[i]))
        }
        return indicatorEntries
    }
}
