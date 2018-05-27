//
//  MedicalSpeciality.swift
//  FollowLife
//
//  Created by Hugo Andres on 23/05/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class MedicalSpeciality {
    public var id: Int
    public var name: String
    public var code: String
    
    public init() {
        self.id = 0
        self.name = ""
        self.code = ""
    }
    
    public init(id: Int, name: String, code: String) {
        self.id = id
        self.name = name
        self.code = code
    }
    
    public init(from jsonObject: JSON){
        self.id = jsonObject["id"].intValue
        self.name = jsonObject["name"].stringValue
        self.code = jsonObject["code"].stringValue
    }
    
    public static func buildCollection(fromJSONArray jsonArray: [JSON]) -> [MedicalSpeciality] {
        var medicalSpecialities = [MedicalSpeciality]()
        let count = jsonArray.count
        for i in 0..<count {
            medicalSpecialities.append(MedicalSpeciality.init(from: jsonArray[i]))
        }
        return medicalSpecialities
    }
}
