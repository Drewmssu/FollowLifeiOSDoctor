//
//  DoctorMedicalSpeciality.swift
//  FollowLife
//
//  Created by Hugo Andres on 23/05/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class DoctorMedicalSpeciality {
    public var id: Int
    public var doctorId: Int
    public var medicalSpeciality: Int
    
    public init() {
        self.id = 0
        self.doctorId = 0
        self.medicalSpeciality = 0
    }
    
    public init(id: Int, doctorId: Int, medicalSpeciality: Int) {
        self.id = id
        self.doctorId = doctorId
        self.medicalSpeciality = medicalSpeciality
    }
    
    public init(from jsonObject: JSON){
        self.id = jsonObject["id"].intValue
        self.doctorId = jsonObject["doctorId"].intValue
        self.medicalSpeciality = jsonObject["medicalSpeciality"].intValue
    }
    
    public static func buildCollection(fromJSONArray jsonArray: [JSON]) -> [DoctorMedicalSpeciality] {
        var doctorMedicalSpecialities = [DoctorMedicalSpeciality]()
        let count = jsonArray.count
        for i in 0..<count {
            doctorMedicalSpecialities.append(DoctorMedicalSpeciality.init(from: jsonArray[i]))
        }
        return doctorMedicalSpecialities
    }
}
