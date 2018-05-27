//
//  District.swift
//  FollowLife
//
//  Created by Hugo Andres on 23/05/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class District {
    public var id: Int
    public var name: String
    
    public init() {
        self.id = 0
        self.name = ""
    }
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    public init(from jsonObject: JSON){
        self.id = jsonObject["id"].intValue
        self.name = jsonObject["name"].stringValue
    }
    
    public static func buildCollection(fromJSONArray jsonArray: [JSON]) -> [District] {
        var districts = [District]()
        let count = jsonArray.count
        for i in 0..<count {
            districts.append(District.init(from: jsonArray[i]))
        }
        return districts
    }
}
