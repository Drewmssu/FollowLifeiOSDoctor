//
//  PatientsProfileViewController.swift
//  FollowLife
//
//  Copyright © 2018 Hillari Zorrilla Delgado. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import FollowLifeFramework

class PatientsProfileViewController: UIViewController {
    
    var doctorId: String = Preference.retreiveData(key: "idDoctor")
    var token: String = Preference.retreiveData(key: "token")
    var patientId: String = Preference.retreiveData(key: "idPatient")
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var prescriptionsButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        prescriptionsButton.layer.cornerRadius = 5
        prescriptionsButton.layer.borderWidth = 1
        prescriptionsButton.layer.borderColor = UIColor(red:0.42, green:0.80, blue:0.80, alpha:1.0).cgColor
        // Do any additional setup after loading the view.
        self.updateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func seePrescriptionAction(_ sender: UIButton) {
        
    }
    
    func updateView() {
        let headers = [
            "X-FLLWLF-TOKEN": self.token,
            "Accept": "application/json"
        ]
        Alamofire.request("\(FollowLifeApi.doctorsUrl)/\(self.doctorId)/patients/\(self.patientId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                let statusCode = response.response?.statusCode
                
                switch response.result {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    
                case .success(let value):
                    let jsonObject = JSON(value)
                    
                    if statusCode == 200 {
                        self.nameLabel.text = "\(jsonObject["name"].stringValue) \(jsonObject["lastName"].stringValue)"
                        self.phoneNumberLabel.text = jsonObject["age"].stringValue
                        self.emailLabel.text = jsonObject["bloodType"].stringValue
                    }
                }
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
