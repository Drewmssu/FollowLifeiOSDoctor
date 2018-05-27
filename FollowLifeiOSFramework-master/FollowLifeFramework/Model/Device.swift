//
//  Device.swift
//  FollowLife
//
//  Created by Hugo Andres on 22/05/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Device {
    public var id: Int
    public var userId: Int
    public var token: String
    public var createdAt: String
    private let dateFormatter: DateFormatter
    
    public init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = 0
        self.userId = 0
        self.token = ""
        self.createdAt = dateFormatter.string(from: Date())
    }
    
    public init(id: Int, userId: Int, token: String, createdAt: Date) {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = id
        self.userId = userId
        self.token = token
        self.createdAt = dateFormatter.string(from: createdAt)
    }
    
    public init(id: Int, userId: Int, token: String, createdAt: String) {
        self.dateFormatter = DateFormatter()
        
        self.id = id
        self.userId = userId
        self.token = token
        self.createdAt = createdAt
    }
    
    public init(from jsonObject: JSON){
        self.dateFormatter = DateFormatter()
        
        self.id = jsonObject["id"].intValue
        self.userId = jsonObject["userId"].intValue
        self.token = jsonObject["token"].stringValue
        self.createdAt = jsonObject["createdAt"].stringValue
    }
    
    public static func buildCollection(fromJSONArray jsonArray: [JSON]) -> [Device] {
        var devices = [Device]()
        let count = jsonArray.count
        for i in 0..<count {
            devices.append(Device.init(from: jsonArray[i]))
        }
        return devices
    }
}
