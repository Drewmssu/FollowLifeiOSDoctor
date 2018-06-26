//
//  PrescriptionListTableViewController.swift
//  FollowLife
//
//  Created by Hillari Zorrilla Delgado on 6/26/18.
//  Copyright © 2018 Hillari Zorrilla Delgado. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FollowLifeFramework

class PrescriptionViewCell: UITableViewCell {
    @IBOutlet weak var prescriptionTypeImageView: UIImageView!
    
    @IBOutlet weak var prescriptionNameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    
}

class PrescriptionListTableViewController: UITableViewController {
    
    let token: String = Preference.retreiveData(key: "token")
    let idDoctor: String = Preference.retreiveData(key: "idDoctor")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPrescription(idPatient: "1")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadPresccriptions() {
//        Alamofire.request("\(FollowLifeApi.doctorsUrl)/\(idDoctor)GET /api/v1/doctors/{doctorId}/patients/{patientId}/prescriptions", method: .get, headers: ["X-FLLWLF-TOKEN": token, "Accept": "application/json"])
//            .responseJSON { (response) in
//
//                let statusCode = response.response?.statusCode
//
//                switch response.result {
//                case .failure(let error):
//                    print("Error: \(error.localizedDescription)")
//
//                case .success(let value):
//
//                    let jsonObject: JSON = JSON(value)
//
//                    if statusCode == 200 {
//                        if let specialties = jsonObject["Result"].array {
//                            for specialty in specialties {
//                                if let name = specialty["Text"].string {
//                                    //self.specialtiesList.append(name)
//                                }
//                            }
//                        }
//                        //self.specialtyPicker.reloadAllComponents()
//                    }
//                }
//        }
    }
    
    func loadPrescription(idPatient: String){
        Alamofire.request("\(FollowLifeApi.doctorsUrl)/\(self.idDoctor)/patients/\(idPatient)/prescriptions", method: .get, encoding: JSONEncoding.default, headers: ["X-FLLWLF-TOKEN": self.token, "Content-type": "application/json"]).responseJSON { (response) in
            
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                
            case .success(let value):
                
                let jsonObject: JSON = JSON(value)
                
                print(statusCode)
                print(jsonObject)
                
                if statusCode == 200 {
                    
                    print(jsonObject)
                    
                    
                }
                else {
                    
                }
                
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PrescriptionViewCell
        
        // let fruitName = fruits[indexPath.row]
        //cell.label?.text = fruitName
        //cell.fruitImageView?.image = UIImage(named: fruitName)
        
        return cell
    }
    
    
}
