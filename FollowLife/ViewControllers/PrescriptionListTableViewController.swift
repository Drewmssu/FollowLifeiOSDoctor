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
    
    func setValues(fromPrecription prescription: Prescription) {
        prescriptionNameLabel.text = prescription.prescriptionTypeId.name
        descriptionLabel.text = prescription.description
        statusLabel.text = (prescription.status == "" || prescription.description == "INA") ? "Not taken" : "taken"
    }
}

class PrescriptionListTableViewController: UITableViewController {
    
    let token: String = Preference.retreiveData(key: "token")
    let idDoctor: String = Preference.retreiveData(key: "idDoctor")
    let patientId: String = Preference.retreiveData(key: "idPatient")
    var prescriptions: [Prescription] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPrescription()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        print("PatientID: \(patientId)")
    }
    
    @IBAction func addPrescriptionAction(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showPrescriptionType", sender: nil)
    }
    
    func loadPrescription() {
        Alamofire.request("\(FollowLifeApi.doctorsUrl)/\(self.idDoctor)/patients/\(self.patientId)/prescriptions", method: .get, encoding: JSONEncoding.default, headers: ["X-FLLWLF-TOKEN": self.token, "Accept": "application/json"]).responseJSON { (response) in
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                
            case .success(let value):
                let jsonObject = JSON(value)["Result"].arrayValue
                
                if statusCode == 200 {
                    for i in 0..<jsonObject.count {
                        let prescriptionType = PrescriptionType.init(id: 0, name: jsonObject[i]["type"].stringValue, code: "")
                        self.prescriptions.append(
                            Prescription.init(id: 0,
                                              doctorId: 0,
                                              prescriptionTypeId: prescriptionType,
                                              frequency: jsonObject[i]["frecuency"].stringValue,
                                              quantity: jsonObject[i]["quantity"].intValue,
                                              durationInDays: jsonObject[i]["durationInDays"].intValue,
                                              description: jsonObject[i]["description"].stringValue,
                                              patientId: 0,
                                              startedAt: jsonObject[i]["startsAt"].stringValue,
                                              finishedAt: jsonObject[i]["expiresAt"].stringValue,
                                              status: nil))
                    }
                    
                    self.tableView?.reloadData()
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.prescriptions.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PrescriptionViewCell
        
        let prescription = self.prescriptions[indexPath.row]
        cell.setValues(fromPrecription: prescription)
        
        return cell
    }
    
    
}
