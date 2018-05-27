//
//  Address.swift
//  FollowLife
//
//  Created by Hugo Andres on 23/05/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Address {
    public var id: Int
    public var districtId: Int
    public var street: String
    public var neighborhood: String
    public var complement: String
    public var number: String
    public var status: String
    public var createdAt: String
    public var updatedAt: String
    private let dateFormatter: DateFormatter
    
    public init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = 0
        self.districtId = 0
        self.street = ""
        self.neighborhood = ""
        self.complement = ""
        self.number = ""
        self.status = ""
        self.createdAt = dateFormatter.string(from: Date())
        self.updatedAt = dateFormatter.string(from: Date())
    }
    
    public init(id: Int, districtId: Int, street: String, neighborhood: String, complement: String, number: String, status: String, createdAt: Date, updatedAt: Date) {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.dateFormatter.timeStyle = .medium
        self.dateFormatter.dateStyle = .long
        
        self.id = id
        self.districtId = districtId
        self.street = street
        self.neighborhood = neighborhood
        self.complement = complement
        self.number = number
        self.status = status
        self.createdAt = dateFormatter.string(from: createdAt)
        self.updatedAt = dateFormatter.string(from: updatedAt)
    }
    
    public init(id: Int, districtId: Int, street: String, neighborhood: String, complement: String, number: String, status: String, createdAt: String, updatedAt: String) {
        self.dateFormatter = DateFormatter()
        
        self.id = id
        self.districtId = districtId
        self.street = street
        self.neighborhood = neighborhood
        self.complement = complement
        self.number = number
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    public init(from jsonObject: JSON){
        self.dateFormatter = DateFormatter()
        
        self.id = jsonObject["id"].intValue
        self.districtId = jsonObject["districtId"].intValue
        self.street = jsonObject["street"].stringValue
        self.neighborhood = jsonObject["neighborhood"].stringValue
        self.complement = jsonObject["complement"].stringValue
        self.number = jsonObject["number"].stringValue
        self.status = jsonObject["status"].stringValue
        self.createdAt = jsonObject["createdAt"].stringValue
        self.updatedAt = jsonObject["updatedAt"].stringValue
    }
    
    public static func buildCollection(fromJSONArray jsonArray: [JSON]) -> [Address] {
        var addresses = [Address]()
        let count = jsonArray.count
        for i in 0..<count {
            addresses.append(Address.init(from: jsonArray[i]))
        }
        return addresses
    }
}
