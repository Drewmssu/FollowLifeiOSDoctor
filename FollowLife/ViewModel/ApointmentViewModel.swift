//
//  AppointmentServices.swift
//  FollowLife
//
//  Created by Francis Marquez on 18/06/18.
//  Copyright © 2018 Hillari Zorrilla Delgado. All rights reserved.
//

import Foundation
import Alamofire
import FollowLifeFramework
import SwiftyJSON

//MARK: Suplemtary class to get and store the necesary values for request
class UserModel: NSObject, NSCoding {
    var userId: Int
    var name: String
    var token: String
    
    init(id: Int, name: String, token: String) {
        self.name = name
        self.token = token
        self.userId = id
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "userId")
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let token = aDecoder.decodeObject(forKey: "token") as! String
        self.init(id: id, name: name, token: token)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(token, forKey: "token")
    }
}


class AppointmentCellModel {
    public var appointmentDate: String
    public var reason: String
    public var status: String
    public var patientName: String
    
    init(appointmentDate: String, reason: String?, status: String, patient: String) {
        self.appointmentDate = appointmentDate
        self.reason = (reason == nil) ? "" : reason!
        self.status = status
        self.patientName = patient
    }
    
    public convenience init(from jsonObject: JSON) {
        self.init(appointmentDate: jsonObject["appointmentDate"].stringValue,
                  reason: jsonObject["reason"].stringValue,
                  status: jsonObject["status"].stringValue,
                  patient: jsonObject["patient"]["Name"].stringValue)
    }
    
    public static func buildCollection(fromJSONArray jsonArray: [JSON]) -> [AppointmentCellModel] {
        var appointments = [AppointmentCellModel]()
        let count = jsonArray.count
        for i in 0..<count {
            appointments.append(AppointmentCellModel.init(from: jsonArray[i]))
        }
        return appointments
    }
}


class AppointmentViewModel {
    
    static var sharedInstance: AppointmentViewModel?
    
    public class func shared() -> AppointmentViewModel {
        if self.sharedInstance == nil {
            self.sharedInstance = AppointmentViewModel()
        }
        return self.sharedInstance!
    }
    
    func getAppointments(id: Int, token: String, success: @escaping ([AppointmentCellModel]) -> Void, failure: @escaping (String) -> Void) {
        
        let url = FollowLifeApi.doctorsUrl + "/\(id)/appointments"
        let header = ["Content-Type" : "application/json" , "X-FLLWLF-TOKEN" : token]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { (jsonData) in
            //let statusCodeOnResponse = jsonData.response?.statusCode
            switch jsonData.result {
            case .success(let json):
                let jsonObject: JSON = JSON(json)
                print("\(jsonObject)")
                let apointmentList = AppointmentCellModel.buildCollection(fromJSONArray: jsonObject["Result"].arrayValue)
                success(apointmentList)
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    func deleteAppointment(doctorId: Int, appointmentId: Int, token: String, success: @escaping (String) -> Void, failure: @escaping (String) -> Void) {
        let url = FollowLifeApi.doctorsUrl + "/\(doctorId)/appointments/\(appointmentId)"
        let header = ["X-FLLWLF-TOKEN" : token]
        
        Alamofire.request(url, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { (jsonData) in
            switch jsonData.result {
            case .success(_):
                success("Appointment Deleted")
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    func addAppointment(params: [String : Any], method: HTTPMethod, token: String, success: @escaping (String) -> Void, failure: @escaping (String) -> Void) {
        
        //To delete values
        var parameters = params
        
        var message: String
        let header = ["Content-Type" : "application/json" , "X-FLLWLF-TOKEN" : token]
        
        var url = FollowLifeApi.doctorsUrl
        if (method == .put || method == .post) {
            if method == .post {
                url += "/\(params["DoctorId"]!)/appointments"
                parameters.removeValue(forKey: "Action")
                parameters.removeValue(forKey: "AppointmentId")
                print("\(params)")
                message = "Appointment added"
            } else {
                url += "/\(params["DoctorId"]!)/appointments/\(params["AppointmentId"])"
                parameters.removeValue(forKey: "PatientId")
                parameters.removeValue(forKey: "DoctorId")
                parameters.removeValue(forKey: "Reason")
                message = "Appointment setted"
            }
            
            Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON { (jsonData) in
                switch jsonData.result {
                case .success(let value):
                    let jsonObject = JSON(value)
                    print("\(jsonObject)")
                    success(message)
                case .failure(let error):
                    failure(error.localizedDescription)
                }
            }
        } else {
            failure("Bad method request")
        }
    }
    
}
