//
//  PatientsProfileTableViewController.swift
//  FollowLife
//
//  Created by Hugo Andres on 26/06/18.
//  Copyright © 2018 Hillari Zorrilla Delgado. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import FollowLifeFramework

private let reuseIdentifier = "PatientCell"

public class PatientProfileTableViewCell: UITableViewCell {
    var id: Int = 0
    @IBOutlet weak var patientNameLabel: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func setValues(fromPatient patient: User) {
        self.id = patient.id
        self.patientNameLabel.text = "\(patient.firstName) \(patient.lastName)"
    }
    
    public func setValues(fromName patientName: String) {
        patientNameLabel.text = patientName
    }
    
}

class PatientsProfileTableViewController: UITableViewController {
    
    var doctorId: String = Preference.retreiveData(key: "idDoctor")
    var token: String = Preference.retreiveData(key: "token")
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        self.updateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func AddPatientAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Patient",
                                      message: "Submit Patient's email.",
                                      preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (action) in
            let textField = alert.textFields![0]
            
            let confirmationAlert = UIAlertController(title: "Confirmation", message: "Are you sure is the correct email?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                let headers = [
                    "X-FLLWLF-TOKEN": self.token,
                    "Accept": "application/json"
                ]
                let parameters = [
                    "Email": textField.text!
                ]
                
                Alamofire.request("\(FollowLifeApi.doctorsUrl)/\(self.doctorId)/membership", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
                    .responseJSON(completionHandler: { (response) in
                        let statusCode = response.response?.statusCode
                        
                        switch response.result {
                        case .failure(let error):
                            print("Error \(error.localizedDescription)")
                            
                        case .success(let value):
                            if statusCode == 200 {
                                let successAlert = UIAlertController(title: "Successful sent", message: "The message is been sent.", preferredStyle: UIAlertControllerStyle.alert)
                                successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                self.present(successAlert, animated: true, completion: nil)
                            } else {
                                let incorrectCredentialAlert = UIAlertController(title: "We have an error", message: "We can't send an email right now.", preferredStyle: UIAlertControllerStyle.alert)
                                incorrectCredentialAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                self.present(incorrectCredentialAlert, animated: true, completion: nil)
                            }
                        }
                    })
            })
            
            let noAction = UIAlertAction(title: "No", style: .destructive, handler: { (action) in
                // MARK: noAction
            })
            
            confirmationAlert.addAction(yesAction)
            confirmationAlert.addAction(noAction)
            
            self.present(confirmationAlert, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            // MARK: didCancel
        }
        
        alert.addTextField {
            (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.clearButtonMode = .whileEditing
        }
        alert.addAction(submitAction)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PatientProfileTableViewCell
        
        let user = self.users[indexPath.row]
        
        cell.setValues(fromPatient: user)
        
        return cell
    }
    
    func updateView() {
        let headers = [
            "X-FLLWLF-TOKEN": self.token,
            "Accept": "application/json"
        ]
        
        Alamofire.request("\(FollowLifeApi.doctorsUrl)/\(doctorId)/patients", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseJSON { (response) in
                let statusCode = response.response?.statusCode
                
                switch response.result {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    
                case .success(let value):
                    let jsonObject = JSON(value)["Result"].arrayValue
                    
                    if statusCode == 200 {
                        for i in 0..<jsonObject.count {
                            self.users.append(User.init(id: jsonObject[i]["id"].intValue,
                                                        sessionToken: nil,
                                                        firstName: jsonObject[i]["name"].stringValue,
                                                        lastName: "",
                                                        email: "",
                                                        profileImage: nil,
                                                        phoneNumber: nil))
                        }
                        
                        self.tableView?.reloadData()
                    } else {
                        // MARK: Error
                    }
                }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath) as! PatientProfileTableViewCell
        /*
        let patientsProfileViewController = storyboard?.instantiateViewController(withIdentifier: "Patient's Profile") as! PatientsProfileViewController
        
        patientsProfileViewController.patientId = String(currentCell.id)
        */
        Preference.saveData(key: "idPatient", value: "\(currentCell.id)")
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
